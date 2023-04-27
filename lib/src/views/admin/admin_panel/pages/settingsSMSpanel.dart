import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable

class AdminSettingsSMS extends StatefulWidget {
  AdminSettingsSMS({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;
  @override
  State createState() => AdminSettingsSMSState();
}

class AdminSettingsSMSState extends mvc.StateMVC<AdminSettingsSMS> {
  String tab = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig(context).screenWidth > 700
          ? SizeConfig(context).screenWidth * 0.75
          : SizeConfig(context).screenWidth,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminSettingHeader(
          icon: const Icon(Icons.settings),
          pagename: 'Settings › SMS',
          button: const {'flag': false},
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: SizeConfig(context).screenWidth > 500 ? 150 : 100,
                child: const Text(
                  'Test Phone Number',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 95, 127)),
                ),
              ),
              SizeConfig(context).screenWidth > 590
                  ? const Padding(padding: EdgeInsets.only(left: 100))
                  : const Flexible(fit: FlexFit.tight, child: SizedBox()),
              Container(
                child: Column(children: [
                  Row(
                    children: [
                      section(
                          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ftwilio.svg?alt=media&token=92b10723-2469-4a13-9b6d-d98615cb59e2',
                          'Twilio'),
                      const Padding(padding: EdgeInsets.only(left: 30)),
                      section(
                          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FBulkSMS.svg?alt=media&token=81da607f-6afa-48bc-b4f5-44933b78b587',
                          'BulkSMS'),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    children: [
                      section(
                          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FInfobip.svg?alt=media&token=1ccad982-3864-467f-a291-40d8887b84d2',
                          'Infobip'),
                      const Padding(padding: EdgeInsets.only(left: 30)),
                      section(
                          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2FMsg91.svg?alt=media&token=bed4c7f9-9581-4158-b544-5e06dff2681e',
                          'Msg91'),
                    ],
                  )
                ]),
              )
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          padding: const EdgeInsets.only(left: 40),
          child: const Text('TWILIO'),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Twilio Account SID',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 95, 127)),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 500,
                      child: Column(children: [
                        Container(
                          width: 400,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 250, 250),
                              border: Border.all(color: Colors.grey)),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 7,
                            onChanged: (value) async {},
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ]),
                    ))
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Twilio Auth Token',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 95, 127)),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 500,
                      child: Column(children: [
                        Container(
                          width: 400,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 250, 250),
                              border: Border.all(color: Colors.grey)),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 7,
                            onChanged: (value) async {},
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ]),
                    ))
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Twilio Phone Number',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 95, 127)),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 500,
                      child: Column(children: [
                        Container(
                          width: 400,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 250, 250),
                              border: Border.all(color: Colors.grey)),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 7,
                            onChanged: (value) async {},
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ]),
                    ))
              ],
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          padding: const EdgeInsets.only(left: 40),
          child: const Text('BULKSMS'),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'BulkSMS Username',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 95, 127)),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 500,
                      child: Column(children: [
                        Container(
                          width: 400,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 250, 250),
                              border: Border.all(color: Colors.grey)),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 7,
                            onChanged: (value) async {},
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ]),
                    ))
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'BulkSMS Password',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 95, 127)),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 500,
                      child: Column(children: [
                        Container(
                          width: 400,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 250, 250),
                              border: Border.all(color: Colors.grey)),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 7,
                            onChanged: (value) async {},
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ]),
                    ))
              ],
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          padding: const EdgeInsets.only(left: 40),
          child: const Text('INFOBIP'),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Infobip Username',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 95, 127)),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 500,
                      child: Column(children: [
                        Container(
                          width: 400,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 250, 250),
                              border: Border.all(color: Colors.grey)),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 7,
                            onChanged: (value) async {},
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ]),
                    ))
              ],
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      'Infobip Password',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 85, 95, 127)),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: 500,
                        child: Column(children: [
                          Container(
                            width: 400,
                            height: 30,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 250, 250, 250),
                                border: Border.all(color: Colors.grey)),
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 7,
                              onChanged: (value) async {},
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(fontSize: 12),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ]),
                      ))
                ],
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          padding: const EdgeInsets.only(left: 40),
          child: const Text('MSG91'),
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Msg91 AuthKey',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 95, 127)),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 500,
                      child: Column(children: [
                        Container(
                          width: 400,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 250, 250, 250),
                              border: Border.all(color: Colors.grey)),
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 7,
                            onChanged: (value) async {},
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ]),
                    ))
              ],
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 100,
                child: Text(
                  'Test Phone Number',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 85, 95, 127)),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: SizedBox(
                    width: 500,
                    child: Column(children: [
                      Container(
                        width: 400,
                        height: 30,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 250, 250),
                            border: Border.all(color: Colors.grey)),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 7,
                          onChanged: (value) async {},
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: '',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const Text(
                        'Your phone number to test the SMS service i.e +12344567890 A test SMS will be sent to this phone number when you test the connection',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ]),
                  ))
            ],
          ),
        ),
        const AdminSettingFooter()
      ]),
    );
  }

  @override
  Widget section(picture, text) {
    return Container(
      width: SizeConfig(context).screenWidth > 470
          ? 130
          : (SizeConfig(context).screenWidth - 100) * 0.8 / 2 - 30,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(35),
            ),
            child: Container(
              margin: const EdgeInsets.all(15),
              child: SvgPicture.network(picture),
            )),
        const Padding(padding: EdgeInsets.only(top: 30)),
        Text(text)
      ]),
    );
  }
}
