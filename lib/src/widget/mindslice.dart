import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class MindSlice extends StatelessWidget {
  MindSlice({
    super.key,
    required this.label,
    required this.image,
    required this.mindFunc,
    required this.disabled,
  });
  String label;
  String image;
  var mindFunc;
  bool disabled;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            disabled ? Colors.grey : const Color.fromARGB(255, 230, 230, 230),
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(21.0)),
        minimumSize: const Size(240, 42),
        maximumSize: const Size(240, 42),
      ),
      onPressed: () {
        print('now click');
        if (!disabled) mindFunc();
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
              Text(
                label,
                style: const TextStyle(
                    color: Color.fromARGB(255, 90, 90, 90),
                    fontFamily: 'var(--body-font-family)',
                    fontWeight: FontWeight.w900,
                    fontSize: 15),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
        ],
      ),
    );
  }
}
