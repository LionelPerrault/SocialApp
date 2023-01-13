import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/widget/interests.dart';

class CreatePageModal extends StatefulWidget {
  BuildContext context;
  late PostController Postcon;
  CreatePageModal({Key? key, required this.context})
      : Postcon = PostController(),
        super(key: key);
  @override
  State createState() => CreatePageModalState();
}

class CreatePageModalState extends mvc.StateMVC<CreatePageModal> {
  bool isSound = false;
  late PostController Postcon;
  Map<String, dynamic> pageInfo = {
    'pageAbout': '',
    'pageInterests': [],
  };
  var privacy = 'public';
  var interest = 'none';
  bool footerBtnState = false;
  @override
  void initState() {
    add(widget.Postcon);
    Postcon = controller as PostController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(
          height: 0,
          indent: 0,
          endIndent: 0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              child: customInput(
                title: 'Name Your Page',
                onChange: (value) async {
                  pageInfo['pageName'] = value;
                  setState(() {});
                },
              ),
            )
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              child: customInput(
                title: 'Page Username',
                hitText: 'https://test.shnatter.com/pages/',
                onChange: (value) {
                  pageInfo['pageUserName'] = value;
                  setState(() {});
                },
              ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              child: customInput(
                title: 'Location',
                onChange: (value) async {
                  pageInfo['pageLocation'] = value;
                  setState(() {});
                },
              ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 400,
              child: titleAndsubtitleInput(
                'About',
                70,
                5,
                (value) async {
                  pageInfo['pageAbout'] = value;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        Container(
          width: 400,
          child: InterestsWidget(
            context: context,
            sendUpdate: (value) {
              pageInfo['pageInterests'] = value;
            },
          ),
        ),
        Container(
          width: 400,
          margin: const EdgeInsets.only(right: 15, bottom: 10),
          child: Row(
            children: [
              const Flexible(fit: FlexFit.tight, child: SizedBox()),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  shadowColor: Colors.grey[400],
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: Size(100, 50),
                ),
                onPressed: () {
                  Navigator.of(widget.context).pop(true);
                },
                child: const Text('Cancel',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  minimumSize: Size(100, 50),
                ),
                onPressed: () {
                  footerBtnState = true;
                  setState(() {});
                  Postcon.createPage(context, pageInfo).then((value) => {
                        footerBtnState = false,
                        setState(() {}),
                        Helper.showToast(value)
                      });
                  print(pageInfo);
                },
                child: footerBtnState
                    ? const SizedBox(
                        width: 10,
                        height: 10.0,
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      )
                    : const Text('Create',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ],
    ));
  }
}

Widget customInput({title, onChange, controller, hitText}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(padding: EdgeInsets.only(top: 10)),
      Text(
        title,
        style: const TextStyle(
            color: Color.fromRGBO(82, 95, 127, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
      const Padding(padding: EdgeInsets.only(top: 2)),
      Container(
        height: 40,
        child: TextField(
          controller: controller,
          onChanged: (value) {
            onChange(value);
          },
          decoration: InputDecoration(
            hintText: hitText,
            contentPadding: const EdgeInsets.only(top: 10, left: 10),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
          ),
        ),
      )
    ],
  );
}

Widget titleAndsubtitleInput(title, height, line, onChange) {
  return Container(
    margin: const EdgeInsets.only(top: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 85, 95, 127)),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: 400,
                height: height,
                child: TextField(
                  maxLines: line,
                  minLines: line,
                  onChanged: (value) {
                    onChange(value);
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10, left: 10),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
