import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  Future<void> showPhotoSelectionMode(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Please select upload photo',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Georgia',
                fontStyle: FontStyle.normal),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Take photo'),
              onPressed: () {
                mindFunc(1);
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Gallery'),
              onPressed: () {
                mindFunc(0);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      child: IgnorePointer(
        ignoring: disabled,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: disabled
                ? Colors.grey
                : const Color.fromARGB(255, 230, 230, 230),
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21.0)),
            minimumSize: const Size(240, 42),
            maximumSize: const Size(240, 42),
          ),
          onPressed: () {
            if (label.toLowerCase() == "upload photos" && !kIsWeb) {
              showPhotoSelectionMode(context);
            } else {
              mindFunc(0);
            }
          },
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 8.0)),
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
        ),
      ),
    );
  }
}
