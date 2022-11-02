import 'dart:ui';

import 'package:flutter/material.dart';

class MyPrimaryButton extends StatelessWidget {
  MyPrimaryButton(
      {super.key,
      required this.onPressed,
      required this.buttonName,
      required this.color,
      this.miniumSize = const Size(200, 40),
      this.isShowProgressive = false});
  final GestureTapCallback onPressed;
  String buttonName;
  Size miniumSize;
  bool isShowProgressive;
  Color color;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shadowColor: Colors.greenAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        minimumSize: miniumSize,
      ),
      onPressed: () {
        this.onPressed();
      },
      child: isShowProgressive
          ? SizedBox(
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
              width: 15,
              height: 15.0,
            )
          : Text(buttonName,
              style: const TextStyle(color: Colors.black, fontSize: 11)),
    );
  }
}
