import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListText extends StatelessWidget {
  ListText(
      {super.key,
      required this.onTap,
      required this.label,
      required this.image});
  Function onTap;
  String label;
  Widget image;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              onTap();
            },
            hoverColor: Colors.blue.withOpacity(0.8),
            highlightColor: Colors.blue.withOpacity(0.8),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 8.0)),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 45.0)),
                    image,
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
          ),
        )

        /*ListTile(
          enabled: true,
          tileColor: Colors.white,
          onTap: () {
            onTap();
          },
          hoverColor: Color.fromRGBO(100, 100, 100, 1),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 8.0)),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 30.0)),
                    image,
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
          ),
        ),*/
        // Container(
        //   width: double.infinity,
        //   height: 0.5,
        //   color: Color.fromRGBO(240, 240, 240, 1),
        // )
      ],
    );
  }
}
