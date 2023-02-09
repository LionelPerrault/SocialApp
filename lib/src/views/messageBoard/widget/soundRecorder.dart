// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

/*
 * Copyright 2018, 2019, 2020, 2021 Dooboolab.
 *
 * This file is part of Flutter-Sound.
 *
 * Flutter-Sound is free software: you can redistribute it and/or modify
 * it under the terms of the Mozilla Public License version 2 (MPL2.0),
 * as published by the Mozilla organization.
 *
 * Flutter-Sound is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * MPL General Public License for more details.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

const theSource = AudioSource.microphone;

/// Example app.
class SoundRecorder extends StatefulWidget {
  const SoundRecorder({super.key});

  @override
  _SoundRecorderState createState() => _SoundRecorderState();
}

class _SoundRecorderState extends State<SoundRecorder> {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  late Timer _timer;
  int counter = 0;
  String recordingTime = "";
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool isRecording = false;
  bool _mRecorderIsInited = false;

  @override
  void initState() {
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
    }
    if (await _mRecorder!.isEncoderSupported(_codec) && !kIsWeb) {
      var dir = await getExternalStorageDirectory();
      _mPath = '${dir?.path}/tau_file.mp4';
      _mRecorderIsInited = true;
      return;
    }

    _mRecorderIsInited = true;
  }

  String twoDigits(int n) {
    return n.toString().padLeft(2, "0");
  }

  String convertSecondsToMMSS(int seconds) {
    int minutes = (seconds / 60).floor();
    seconds = seconds - (minutes * 60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // ----------------------  Here is the code for recording and playback -------
  void startTimer() {
    setState(() {
      counter = 0;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        counter++;

        setState(() {});
      },
    );
  }

  void record() {
    if (!_mRecorderIsInited) {
      return;
    }

    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {
        isRecording = true;
        startTimer();
      });
    });
  }

  void stopRecorder() async {
    if (!_mRecorderIsInited) {
      return;
    }
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        isRecording = false;
        _timer.cancel();
      });
    });
  }

// ----------------------------- UI --------------------------------------------

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return !isRecording
          ? InkWell(
              onTap: () {
                record();
              },
              child: Container(
                  margin: EdgeInsets.only(left: 10),
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue),
                  child: Row(
                    children: const [
                      SizedBox(width: 10),
                      Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Record",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    ],
                  )))
          : InkWell(
              onTap: () {
                stopRecorder();
              },
              child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 158,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.stop,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Recording ${convertSecondsToMMSS(counter)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )
                    ],
                  )));
    }

    return makeBody();
  }
}
