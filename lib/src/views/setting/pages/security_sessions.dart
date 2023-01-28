import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/utils/svg.dart';
import 'package:shnatter/src/views/box/daytimeM.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/setting/widget/setting_footer.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:shnatter/src/widget/mindslice.dart';
import 'package:shnatter/src/widget/startedInput.dart';

class SettingSecuritySessScreen extends StatefulWidget {
  SettingSecuritySessScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingSecuritySessScreenState();
}

// ignore: must_be_immutable
class SettingSecuritySessScreenState extends State<SettingSecuritySessScreen> {
  var setting_security = {};
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 20, left: 30),
        child: Column(
          children: [
            SettingHeader(
              icon: Icon(
                Icons.security_outlined,
                color: Color.fromARGB(255, 139, 195, 74),
              ),
              pagename: 'Manage Sessions',
              button: {'flag': false},
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              width: SizeConfig(context).screenWidth * 0.6,
              child: Column(
                children: [
                  Container(
                    // color: Colors.white,
                    padding: EdgeInsets.all(20.0),
                    child: Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: IntrinsicColumnWidth(),
                        1: IntrinsicColumnWidth(),
                        2: IntrinsicColumnWidth(),
                        3: IntrinsicColumnWidth(),
                        4: FixedColumnWidth(200),
                        5: IntrinsicColumnWidth(),
                      },
                      border: TableBorder.all(),
                      // defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            Container(
                              height: 40,
                              padding:
                                  EdgeInsets.only(left: 10, top: 15, right: 30),
                              child: const Text('1'),
                            ),
                            Container(
                              height: 40,
                              padding:
                                  EdgeInsets.only(left: 10, top: 15, right: 30),
                              child: const Text('Chrome'),
                            ),
                            Container(
                              height: 40,
                              padding:
                                  EdgeInsets.only(left: 10, top: 15, right: 30),
                              child: const Text('Windows 10'),
                            ),
                            Container(
                              height: 40,
                              padding:
                                  EdgeInsets.only(left: 10, top: 15, right: 30),
                              child: const Text('7 months ago'),
                            ),
                            Container(
                              width: 100,
                              height: 40,
                              padding:
                                  EdgeInsets.only(left: 10, top: 15, right: 30),
                              child: const Text('178.238.174.71'),
                            ),
                            Container(
                              width: 26,
                              height: 26,
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                color: Colors.grey[400],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(4),
                                  backgroundColor:
                                      Color.fromARGB(255, 245, 54, 92),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                  minimumSize: const Size(26, 26),
                                  maximumSize: const Size(26, 26),
                                ),
                                onPressed: () {
                                  // uploadImage();
                                  () => {};
                                },
                                child: const Icon(Icons.delete,
                                    color: Colors.white, size: 16.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SettingFooter(
              onClick: () {},
            )
          ],
        ));
  }
}
