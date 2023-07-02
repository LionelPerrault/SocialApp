import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/faq.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class GetStartedScreen extends StatefulWidget {
  GetStartedScreen({Key? key}) : super(key: key);
  @override
  State createState() => GetStartedScreenState();
}

class GetStartedScreenState extends mvc.StateMVC<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  double _sliderValue = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter.mp4?alt=media&token=896f75f3-e501-4c7b-81e4-f182a9b23c5b')
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
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/get-started.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: SizeConfig(context).screenWidth,
          margin: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  'assets/images/shnatter-logo-login.svg',
                  semanticsLabel: 'Logo',
                  width: 200,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: SizeConfig(context).screenWidth * 0.8,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          print('object');
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
                  )
                ],
              ),
              const SizedBox(height: 40),
              SizeConfig(context).screenWidth < 700
                  ? const Text(
                      'Welcome to Shnatter - Welcome Home !',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 32,
                        letterSpacing: 0.3,
                      ),
                    )
                  : const SizedBox(),
              Container(
                alignment: Alignment.center,
                width: SizeConfig(context).screenWidth,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Expanded(child: SizedBox()),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizeConfig(context).screenWidth >= 700
                            ? const Text(
                                'Welcome to Shnatter - Welcome Home !',
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 32,
                                  letterSpacing: 0.3,
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(height: 30),
                        // ignore: prefer_const_constructors
                        SizeConfig(context).screenWidth < 700
                            ? SizedBox(
                                width: SizeConfig(context).screenWidth - 60,
                                child: const Text(
                                  'Preregistration starts from June 30th to July 31st.\nRegister now and receive 1000 Tokens welcome gift !\nThe Website is full usable also during this time.\n',
                                  style: TextStyle(
                                    letterSpacing: 0.4,
                                    height: 1.5,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            : const Text(
                                'Preregistration starts from June 30th to July 31st.\nRegister now and receive 1000 Tokens welcome gift !\nThe Website is full usable also during this time.\n',
                                style: TextStyle(
                                  letterSpacing: 0.4,
                                  height: 1.5,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 18,
                                ),
                              ),
                        SizeConfig(context).screenWidth < 700
                            ? SizedBox(
                                width: SizeConfig(context).screenWidth - 60,
                                child: const Text(
                                  'If you wish to buy larger amounts of Tokens to a reduced price,',
                                  style: TextStyle(
                                    letterSpacing: 0.4,
                                    height: 1.5,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            : const Text(
                                'If you wish to buy larger amounts of Tokens to a reduced price,',
                                style: TextStyle(
                                  letterSpacing: 0.4,
                                  height: 1.5,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 18,
                                ),
                              ),
                        SizeConfig(context).screenWidth < 700
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'please visit ',
                                    style: TextStyle(
                                      letterSpacing: 0.4,
                                      height: 1.5,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      var url = Uri.parse(
                                          'https://shnatterprebuy.com/');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: const Text(
                                      'www.shantterprebuy.com',
                                      style: TextStyle(
                                        letterSpacing: 0.4,
                                        height: 1.5,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ' password: Shnatter',
                                    style: TextStyle(
                                      letterSpacing: 0.4,
                                      height: 1.5,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'please visit ',
                                    style: TextStyle(
                                      letterSpacing: 0.4,
                                      height: 1.5,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontSize: 18,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      var url = Uri.parse(
                                          'https://shnatterprebuy.com/');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: const Text(
                                      'www.shantterprebuy.com',
                                      style: TextStyle(
                                        letterSpacing: 0.4,
                                        height: 1.5,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ' password: Shnatter',
                                    style: TextStyle(
                                      letterSpacing: 0.4,
                                      height: 1.5,
                                      color: Colors.white,
                                      decoration: TextDecoration.none,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                        SizeConfig(context).screenWidth < 700
                            ? SizedBox(
                                width: SizeConfig(context).screenWidth - 60,
                                child: const Text(
                                  'For questions, please contact us on: shnatterteam@gmail.com\n\nYour Shnatter Team',
                                  style: TextStyle(
                                    letterSpacing: 0.4,
                                    height: 1.5,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            : const Text(
                                'For questions, please contact us on: shnatterteam@gmail.com\n\nYour Shnatter Team',
                                style: TextStyle(
                                  letterSpacing: 0.4,
                                  height: 1.5,
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 18,
                                ),
                              ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    minimumSize: const Size(150, 60),
                    maximumSize: const Size(150, 60),
                  ),
                  onPressed: () async {
                    Navigator.pushNamed(context, RouteNames.login);
                  },
                  child: const Text(
                    'Get Started!',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              kIsWeb
                  ? Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/appstore-badge.png',
                                width: 120,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/google-play-badge.png',
                                width: 120,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () async {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const FAQScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(5),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(33)),
                          border: Border.all(color: Colors.blue, width: 2)),
                      child: Image.asset(
                        'images/faq.png',
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var url = Uri.parse('https://twitter.com/shnatterteam');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(5),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(33)),
                          border: Border.all(color: Colors.blue, width: 2)),
                      child: SvgPicture.asset(
                        'svg/twitter.svg',
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
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
