import 'package:flutter/material.dart';
import 'package:shnatter/src/views/contactus.dart';
import 'package:shnatter/src/views/privacy.dart';
import 'package:shnatter/src/views/terms.dart';

import '../routes/route_names.dart';
import 'about.dart';

class footbar extends StatefulWidget {
  const footbar({Key? key}) : super(key: key);
  @override
  State createState() => footbarState();
}

class footbarState extends State<footbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 1),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 10)),
            text('@ 2023 Shnatter', const Color.fromRGBO(150, 150, 150, 1), 11),
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
                        builder: (BuildContext context) => const AboutScreen(),
                      ),
                    ),
                  },
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'About',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                InkWell(
                  onTap: () => {
                    Navigator.pushNamed(context, RouteNames.terms),
                  },
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Terms',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                InkWell(
                  onTap: () => {
                    Navigator.pushNamed(context, RouteNames.privacy),
                  },
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Privacy',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                InkWell(
                  onTap: () => {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const ContactUs(),
                      ),
                    ),
                  },
                  child: GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Contact Us',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                // text('Directory', Colors.grey, 11),
              ]),
            )
          ],
        ));
  }
}

class footbarM extends StatefulWidget {
  const footbarM({Key? key}) : super(key: key);
  @override
  State createState() => footbarMState();
}

class footbarMState extends State<footbarM> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: 75,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 1),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
                text('@ 2023 Shnatter', const Color.fromRGBO(150, 150, 150, 1),
                    13),
                const Padding(padding: EdgeInsets.only(left: 10)),
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                    // ignore: sort_child_properties_last
                    child: InkWell(
                      onTap: () => {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const AboutScreen(),
                          ),
                        ),
                      },
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'About',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    flex: 1),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  // ignore: sort_child_properties_last
                  child: InkWell(
                    onTap: () => {
                      Navigator.pushNamed(context, RouteNames.terms),
                    },
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Terms',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  // ignore: sort_child_properties_last
                  child: InkWell(
                    onTap: () => {
                      Navigator.pushNamed(context, RouteNames.privacy),
                    },
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Privacy',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                // text('Terms', Colors.grey, 13),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  // ignore: sort_child_properties_last
                  child: InkWell(
                    onTap: () => {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const ContactUs(),
                        ),
                      ),
                    },
                    child: GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Contact Us',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                // const Padding(padding: EdgeInsets.only(left: 10)),
                // Expanded(
                //   // ignore: sort_child_properties_last
                //   child: text('Directory', Colors.grey, 13),
                //   flex: 1,
                // ),
                const Padding(padding: EdgeInsets.only(right: 10)),
              ],
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
