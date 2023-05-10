import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import '../helpers/helper.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);
  @override
  State createState() => ContactUsState();
}

class ContactUsState extends mvc.StateMVC<ContactUs> {
  Map contactUs = {};

  TextEditingController emailCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController messageCon = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  bool isSending = false;

  sendContact() async {
    isSending = true;
    setState(() {});
    String email = emailCon.text;
    String name = nameCon.text;
    String message = messageCon.text;
    if (!email.contains('@') || !email.contains('.')) {
      Helper.showToast('Please insert valid email');
      isSending = false;
      setState(() {});
      return;
    }
    if (name == '' || message == '') {
      Helper.showToast('Please fill all field');
      isSending = false;
      setState(() {});
      return;
    }
    var reportSnap = await FirebaseFirestore.instance
        .collection(Helper.adminPanel)
        .doc('report')
        .get();
    List contactUsDatas = reportSnap.data()!['contactUs'];

    contactUsDatas = [
      {
        'email': email,
        'name': name,
        'message': message,
      },
      ...contactUsDatas,
    ];
    await FirebaseFirestore.instance
        .collection(Helper.adminPanel)
        .doc('report')
        .update({'contactUs': contactUsDatas});

    emailCon.text = '';
    nameCon.text = '';
    messageCon.text = '';
    isSending = false;
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(left: 20),
                    // alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.black,
                        size: 20.0,
                      ),
                      tooltip: 'Close',
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 133,
                      child: Container(
                          color: Colors.blue,
                          child: const Center(
                            child: Text(
                              'Contact Us',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 130,
                    ),
                    padding: const EdgeInsets.all(25),
                    width: 1000,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.2),
                          blurRadius: 14.0,
                          spreadRadius: 4,
                          offset: Offset(
                            1,
                            3,
                          ),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: 700,
                                child: titleAndsubtitleInput(
                                    'Your Name', 50, 1, nameCon),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: 700,
                                child: titleAndsubtitleInput(
                                    'Your Email Address', 50, 1, emailCon),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: 700,
                                child: titleAndsubtitleInput(
                                    'Your Message', 100, 4, messageCon),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(3),
                                    backgroundColor: Colors.blue,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                    minimumSize: const Size(140, 50),
                                    maximumSize: const Size(140, 50),
                                  ),
                                  onPressed: () {
                                    if (!isSending) sendContact();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: isSending
                                        ? const [
                                            SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: CircularProgressIndicator(
                                                  color: Colors.grey),
                                            )
                                          ]
                                        : const [
                                            Icon(Icons.send),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Send Message',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleAndsubtitleInput(title, double height, line, controller) {
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
                child: SizedBox(
                  width: 400,
                  height: height,
                  child: Column(
                    children: [
                      TextField(
                        maxLines: line,
                        minLines: line,
                        controller: controller,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10, left: 10),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
