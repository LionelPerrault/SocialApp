import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class ListText extends StatelessWidget {
  ListText(
      {super.key, required this.onTap, required this.label, this.image = ''});
  Function onTap;
  String label;
  String image;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 8.0)),
          Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 45.0)),
              SvgPicture.network(
                image,
                width: 21,
              ),
              const Padding(padding: EdgeInsets.only(left: 20.0)),
              Text(
                label,
                style: const TextStyle(
                    color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 8.0)),
        ],
      ),
    );
  }
}
