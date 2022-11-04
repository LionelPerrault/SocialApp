
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class ListText extends StatelessWidget {
  ListText(
      {super.key,
      required this.onTap,
      required this.label,
      required this.icon});
  final GestureTapCallback onTap;
  String label;
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 8.0)),
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 45.0)),
            icon,
            const Padding(padding: EdgeInsets.only(left: 15.0)),
            RichText(
              text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: label,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 90, 90, 90),
                            fontSize: 13),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {onTap;})
                  ]),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10.0)),
      ],
    );
  }
}
