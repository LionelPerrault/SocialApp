// ignore_for_file: must_be_immutable
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          minimumSize: miniumSize,
        ),
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isShowProgressive
                ? const SizedBox(
                    width: 10,
                    height: 10.0,
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                  )
                : Container(),
            isShowProgressive
                ? const Padding(padding: EdgeInsets.only(left: 10))
                : Container(),
            Text(buttonName,
                style: const TextStyle(color: Colors.black, fontSize: 11)),
          ],
        ));
  }
}
