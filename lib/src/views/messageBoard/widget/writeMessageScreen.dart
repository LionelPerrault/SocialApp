// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:permission_handler/permission_handler.dart';
import 'package:shnatter/src/controllers/MessageController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:flutter_sound/flutter_sound.dart';
import "./soundRecorder.dart";

// ignore: must_be_immutable
class WriteMessageScreen extends StatefulWidget {
  String type;
  Function goMessage;

  WriteMessageScreen({Key? key, required this.type, required this.goMessage})
      : con = MessageController(),
        super(key: key);
  final MessageController con;
  @override
  State createState() => WriteMessageScreenState();
}

class WriteMessageScreenState extends mvc.StateMVC<WriteMessageScreen> {
  bool check1 = false;
  bool check2 = false;
  bool isShift = false;
  bool isEnter = false;
  bool showRecoder = false;
  bool showEmojicon = false;
  bool recordingStarted = false;
  String recordingPath = "";
  FlutterSound flutterSound = FlutterSound();

  String data = '';
  late MessageController con;
  var userInfo = UserManager.userInfo;
  var emojiList = <Widget>[];
  late FocusNode _focusNode;
  late FlutterSoundRecorder _recordingSession;
  String pathToAudio = '';
  var t = [];
  TextEditingController content = TextEditingController();
  @override
  void initState() {
    add(widget.con);
    con = controller as MessageController;
    _focusNode = FocusNode(
      onKey: (FocusNode node, RawKeyEvent evt) {
        if (!evt.isShiftPressed && evt.logicalKey.keyLabel == 'Enter') {
          if (evt is RawKeyDownEvent) {
            sendMessage();
          }
          return KeyEventResult.handled;
        } else {
          return KeyEventResult.ignored;
        }
      },
    );
    initializer();
    super.initState();
  }

  void initializer() async {
    pathToAudio = '/sdcard/Download/temp.wav';
    _recordingSession = FlutterSoundRecorder();
  }

  Future<void> startRecording() async {
    recordingStarted = true;
    await _recordingSession.startRecorder(
      toFile: pathToAudio,
      codec: Codec.pcm16WAV,
    );
    setState(() {});
  }

  Future<void> stopRecording() async {
    await _recordingSession.stopRecorder();

    recordingStarted = false;
    setState(() {});
  }

  var audioPath = '';
  saveFilePath(value) {
    audioPath = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        con.progress == 0
            ? Container()
            : AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: double.infinity,
                margin:
                    EdgeInsets.only(right: 300 - (300 * con.progress / 100)),
                height: 2,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(2))),
              ),
        SizedBox(
          height: 10,
        ),
        if (showRecoder)
          SoundRecorder(
            savePath: saveFilePath,
          ),
        if (!showRecoder)
          SizedBox(
            height: 35,
            child: TextFormField(
              focusNode: _focusNode,
              controller: con.textController,
              onChanged: ((value) {
                data = value;
              }),
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: 'Write message',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 0, right: 15),
              ),
            ),
          ),
        Row(children: [
          const Padding(padding: EdgeInsets.only(left: 10)),
          MouseRegion(
            child: GestureDetector(
              onTap: () async {
                showRecoder = false;
                setState(() {});
                final status = await Permission.photos.request();

                if (status.isPermanentlyDenied) {
                  //Permission.photos.request();
                  openAppSettings();
                }
                if (status.isGranted) {
                  con.uploadImage(widget.type, 'image');
                  if (widget.type == 'new') {
                    widget.goMessage('message-list');
                  }
                }
              },
              child: const Icon(
                Icons.photo_size_select_actual_rounded,
                size: 20,
                color: Color.fromRGBO(175, 175, 175, 1),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          GestureDetector(
              onTap: () {
                setState(() {
                  showRecoder = !showRecoder;
                  if (showRecoder) showEmojicon = false;
                });
                widget.goMessage(showEmojicon);
              },
              child: const Icon(
                Icons.mic,
                size: 20,
                color: Color.fromRGBO(175, 175, 175, 1),
              )),
          const Padding(padding: EdgeInsets.only(left: 10)),
          MouseRegion(
            child: GestureDetector(
                onTap: () {
                  showRecoder = false;
                  if (con.isShowEmoticon == false) {
                    showEmojicon = true;
                  } else {
                    showEmojicon = false;
                  }
                  setState(() {});
                  widget.goMessage(showEmojicon);
                },
                child: Icon(
                  Icons.emoji_emotions,
                  size: 20,
                  color: Color.fromRGBO(175, 175, 175, 1),
                )),
          ),
          Flexible(fit: FlexFit.tight, child: SizedBox()),
          ElevatedButton(
            onPressed: () async {
              if (showRecoder && audioPath != "") {
                await con.uploadFile(XFile(audioPath), widget.type, 'audio');
                if (widget.type == 'new') {
                  widget.goMessage('message-list');
                }
                showRecoder = false;
                setState(() {});
              } else {
                sendMessage();
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(33, 37, 41, 1),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                minimumSize: Size(60, 38),
                maximumSize: Size(60, 38)),
            child: Text(
              'Send',
              style: TextStyle(
                  fontFamily: 'Hind', color: Colors.white, fontSize: 11),
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 10)),
        ]),
      ],
    );
  }

  sendMessage() async {
    if (con.textController.text.isEmpty) {
      setState(() {});
      return;
    }
    bool success =
        await con.sendMessage(widget.type, 'text', con.textController.text);
    if (widget.type == 'new' && success) {
      widget.goMessage('message-list');
    }
    if (con.chattingUser != '' && con.textController.text != '') {
      con.textController.text = '';
      setState(() {});
    }
    // ignore: empty_catches
  }
}
