// This is a minimal example demonstrating a play/pause button and a seek bar.
// More advanced examples demonstrating other features can be found in the same
// directory as this example in the GitHub repository.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerWidget({Key? key, required this.videoURL}) : super(key: key);

  String videoURL;

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  double _sliderValue = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {
        _sliderValue = _controller.value.position.inMilliseconds.toDouble();
      });
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double videoHeight = MediaQuery.of(context).size.width *
        (9 / 16); // Set the video height based on aspect ratio (16:9)
    return Container(
      height: videoHeight,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.grey),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
                if (_isPlaying) {
                  _controller.play();
                  startTimer();
                } else {
                  _controller.pause();
                  stopTimer();
                }
              },
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                      if (_isPlaying) {
                        _controller.play();
                        startTimer();
                      } else {
                        _controller.pause();
                        stopTimer();
                      }
                    },
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _sliderValue,
                      min: 0.0,
                      max: _controller.value.duration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                        _controller
                            .seekTo(Duration(milliseconds: value.toInt()));
                      },
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                    ),
                  ),
                  Text(
                    durationToString(_controller.value.duration),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _sliderValue = _controller.value.position.inMilliseconds.toDouble();
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String durationToString(Duration duration) {
    return duration.toString().split('.').first;
  }
}

/// Displays the play/pause button and volume/speed sliders.
// class ControlButtons extends StatelessWidget {
//   const ControlButtons(this.player, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Opens volume slider dialog
//         IconButton(
//           icon: const Icon(Icons.volume_up),
//           onPressed: () {
//             showSliderDialog(
//               context: context,
//               title: "Adjust volume",
//               divisions: 10,
//               min: 0.0,
//               max: 1.0,
//               value: player.volume,
//               stream: player.volumeStream,
//               onChanged: player.setVolume,
//             );
//           },
//         ),

//         /// This StreamBuilder rebuilds whenever the player state changes, which
//         /// includes the playing/paused state and also the
//         /// loading/buffering/ready state. Depending on the state we show the
//         /// appropriate button or loading indicator.
//         StreamBuilder<PlayerState>(
//           stream: player.playerStateStream,
//           builder: (context, snapshot) {
//             final playerState = snapshot.data;
//             final processingState = playerState?.processingState;
//             final playing = playerState?.playing;
//             if (processingState == ProcessingState.loading ||
//                 processingState == ProcessingState.buffering) {
//               return Container(
//                 margin: const EdgeInsets.all(8.0),
//                 width: 64.0,
//                 height: 64.0,
//                 child: const CircularProgressIndicator(),
//               );
//             } else if (playing != true) {
//               return IconButton(
//                 icon: const Icon(Icons.play_arrow),
//                 iconSize: 64.0,
//                 onPressed: player.play,
//               );
//             } else if (processingState != ProcessingState.completed) {
//               return IconButton(
//                 icon: const Icon(Icons.pause),
//                 iconSize: 64.0,
//                 onPressed: player.pause,
//               );
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.replay),
//                 iconSize: 64.0,
//                 onPressed: () => player.seek(Duration.zero),
//               );
//             }
//           },
//         ),
//         // Opens speed slider dialog
//         StreamBuilder<double>(
//           stream: player.speedStream,
//           builder: (context, snapshot) => IconButton(
//             icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             onPressed: () {
//               showSliderDialog(
//                 context: context,
//                 title: "Adjust speed",
//                 divisions: 10,
//                 min: 0.5,
//                 max: 1.5,
//                 value: player.speed,
//                 stream: player.speedStream,
//                 onChanged: player.setSpeed,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
