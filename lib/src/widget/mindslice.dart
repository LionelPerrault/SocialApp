import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class MindSlice extends StatelessWidget {
  MindSlice(
      {super.key,
      required this.onTap,
      required this.label,
      required this.image,
      required this.mindFunc});
  Function onTap;
  String label;
  String image;
  Function mindFunc;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.0)),
        minimumSize: const Size(240, 42),
        maximumSize: const Size(240, 42),
      ),
      onPressed: () {
        mindFunc(context);
      },
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 11.0)),
          Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 12.0)),
              SvgPicture.network(
                image,
                width: 22,
              ),
              const Padding(padding: EdgeInsets.only(left: 12.0)),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: label,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 90, 90, 90),
                          fontFamily: 'var(--body-font-family)',
                          fontWeight: FontWeight.w900,
                          fontSize: 15),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          onTap();
                        })
                ]),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
        ],
      ),
    );
  }
}
