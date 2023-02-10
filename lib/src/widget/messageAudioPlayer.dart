// This is a minimal example demonstrating a play/pause button and a seek bar.
// More advanced examples demonstrating other features can be found in the same
// directory as this example in the GitHub repository.

// ignore_for_file: depend_on_referenced_packages

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'commonmessage.dart';

// ignore: must_be_immutable
class MessageAudioPlayer extends StatefulWidget {
  MessageAudioPlayer({Key? key, required this.audioURL}) : super(key: key);

  String audioURL;

  @override
  MessageAudioPlayerState createState() => MessageAudioPlayerState();
}

class MessageAudioPlayerState extends State<MessageAudioPlayer>
    with WidgetsBindingObserver {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream
        .listen((event) {}, onError: (Object e, StackTrace stackTrace) {});
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(widget.audioURL)));
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);

    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 250,
        height: 50,
        decoration: const BoxDecoration(
            color: Color.fromARGB(74, 3, 244, 164),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlButtons(_player),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: _player.seek,
                );
              },
            ),
          ],
        ));
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const CircularProgressIndicator();
        } else if (playing != true) {
          return InkWell(
            onTap: player.play,
            child: const Icon(Icons.play_arrow,
                size: 36.0, color: Colors.lightBlue),
          );
        } else if (processingState != ProcessingState.completed) {
          return InkWell(
            onTap: player.pause,
            child: const Icon(
              Icons.pause,
              size: 36.0,
              color: Colors.lightBlue,
            ),
          );
        } else {
          return InkWell(
            onTap: () => player.seek(Duration.zero),
            child:
                const Icon(Icons.replay, size: 36.0, color: Colors.lightBlue),
          );
        }
      },
    );
  }
}
