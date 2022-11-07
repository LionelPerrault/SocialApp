import 'package:flutter/material.dart';
import 'package:shnatter/src/utils/size_config.dart';

Widget footbar(BuildContext context) {
  return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 1),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.only(left: 10)),
          text('@ 2022 Shnatter', const Color.fromRGBO(150, 150, 150, 1), 11),
          const Padding(padding: EdgeInsets.only(left: 20)),
          Image.network(
            'https://test-file.shnatter.com/uploads/flags/en_us.png',
            width: 11,
          ),
          const Padding(padding: EdgeInsets.only(left: 5)),
          text('English', const Color.fromRGBO(150, 150, 150, 1), 11),
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Row(children: [
              text('About', Colors.grey, 11),
              const Padding(padding: EdgeInsets.only(left: 5)),
              text('Terms', Colors.grey, 11),
              const Padding(padding: EdgeInsets.only(left: 5)),
              text('Contact Us', Colors.grey, 11),
              const Padding(padding: EdgeInsets.only(left: 5)),
              text('Directory', Colors.grey, 11),
            ]),
          )
        ],
      ));
}

Widget text(String title, Color color, double size) {
  return Text(title, style: TextStyle(color: color, fontSize: size));
}
