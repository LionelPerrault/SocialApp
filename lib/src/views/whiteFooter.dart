// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/terms.dart';

import 'about.dart';

// ignore: camel_case_types
class footbar extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  footbar({Key? key}) : super(key: key);
  @override
  State createState() => footbarState();
}

// ignore: camel_case_types
class footbarState extends State<footbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig(context).screenWidth < 600
            ? SizeConfig(context).screenWidth
            : 600,
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 10)),
            text('@ 2023 Shnatter', Colors.black, 11),
            const Padding(padding: EdgeInsets.only(left: 20)),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Row(children: [
                InkWell(
                  onTap: () => {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => AboutScreen(),
                      ),
                    ),
                  },
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'About',
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                InkWell(
                  onTap: () => {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => TermsScreen(),
                      ),
                    ),
                  },
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Terms',
                        style: TextStyle(fontSize: 13, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 5)),
                text('Contact Us', Colors.black, 11),
                const Padding(padding: EdgeInsets.only(left: 5)),
                text('Directory', Colors.black, 11),
              ]),
            ),
          ],
        ));
  }
}

// ignore: camel_case_types
class rightFootbar extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  rightFootbar({Key? key}) : super(key: key);
  @override
  State createState() => rightFootbarState();
}

// ignore: camel_case_types
class rightFootbarState extends State<rightFootbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: 75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
                text('@ 2023 Shnatter', Colors.black, 13),
                const Padding(padding: EdgeInsets.only(left: 10)),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            const Divider(
              height: 1,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              // margin: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Expanded(
                      // ignore: sort_child_properties_last
                      child: InkWell(
                        onTap: () => {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => AboutScreen(),
                            ),
                          ),
                        },
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'About',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      flex: 1),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Expanded(
                    // ignore: sort_child_properties_last
                    child: InkWell(
                      onTap: () => {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => TermsScreen(),
                          ),
                        ),
                      },
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Terms',
                            style: TextStyle(fontSize: 11, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  // text('Terms', Colors.grey, 13),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Expanded(
                    // ignore: sort_child_properties_last
                    child: text('Contact Us', Colors.black, 11),
                    flex: 1,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  Expanded(
                    // ignore: sort_child_properties_last
                    child: text('Directory', Colors.black, 11),
                    flex: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget text(String title, Color color, double size) {
  return Text(title, style: TextStyle(color: color, fontSize: size));
}
