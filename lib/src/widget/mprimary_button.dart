import 'dart:ui';

import 'package:flutter/material.dart';

class MyPrimaryButton extends StatelessWidget {
    MyPrimaryButton({super.key, required this.onPressed,required this.buttonName, this.miniumSize = const Size(200, 50), this.isShowProgressive = false});
    final GestureTapCallback onPressed;
    String buttonName; 
    Size miniumSize;
    bool isShowProgressive;
    @override
    Widget build(BuildContext context) {
      return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.greenAccent,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                minimumSize: miniumSize,
              ),
              onPressed: () { this.onPressed(); },
              child: 
                  isShowProgressive?  SizedBox( child:const CircularProgressIndicator(color: Colors.white,), width: 15, height: 15.0,) :
                  Text(buttonName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            );
  }
}