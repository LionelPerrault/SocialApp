
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class SuggestionHeader extends StatelessWidget {

  SuggestionHeader(
      {super.key,
      required this.onTap,
      required this.onChange,
      required this.bigLabel,
      required this.smallLabel,
      required this.state});
  final GestureTapCallback onTap;
  final GestureTapCallback onChange;
  String bigLabel;
  String smallLabel;
  bool state;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 8.0)),
        Divider(
          color: Colors.black
        ),
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 45.0)),
            Text(bigLabel,
            style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12)),
            const Padding(padding: EdgeInsets.only(left: 30.0)),
            RichText(
              text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: smallLabel,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 90, 90, 90),
                            fontSize: 12),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {onTap;})
                  ]),
            ),
            const Padding(padding: EdgeInsets.only(left: 1.0)),
            SizedBox(
              height: 20,
              child: Transform.scale(
                scaleX: 0.55,
                scaleY: 0.55,
                child: CupertinoSwitch(
                  //thumbColor: kprimaryColor,
                  // activeColor: kprimaryColor,
                  value: state,
                  onChanged: (value) {
                    ()=>{print('object')};
                  },
                ),
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 8.0)),
      ],
    );
  }
}
