
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import '../controllers/HomeController.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetScreen extends StatefulWidget {
    ResetScreen({Key? key})
        : con = HomeController(),
          super(key: key);
    final HomeController con;

    @override
    State createState() => ResetScreenState();
}

class ResetScreenState extends mvc.StateMVC<ResetScreen> {
    
    bool check1 = false;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    void initState() {
      add(widget.con);
      con = controller as HomeController;
      super.initState();
    }

    late HomeController con;
    @override
    Widget build(BuildContext context) {
      
      return Scaffold(
          body: Container(alignment: Alignment.center,
            child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top:60.0),),
              Container(
                color: Colors.blue,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left:45.0),),
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: SvgPicture.network('https://test.shnatter.com/content/themes/default/images/headers/undraw_message_sent_1030.svg'),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(padding: EdgeInsets.only(left:60.0),),
                            Text('Reset Password',
                              style: TextStyle(
                              color: Colors.white,
                              fontSize: 22)),
                            Text('Enter the email address you signed up with and we\'ll email you a reset link',
                              style: TextStyle(
                              color: Colors.white,
                              fontSize: 12)),
                      ],
                    ),
                    // SvgPicture.network('https://test.shnatter.com/content/themes/default/images/headers/undraw_message_sent_1030.svg'),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 7.0,
                          spreadRadius: 0.1,
                          offset: Offset(
                            1,
                            1,
                          ),
                        )
                      ],
                    ),
                width: 340,
                height: 180,
                child: Column(children: [
                  const Padding(padding: EdgeInsets.only(top: 35),),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 40.0),
                    child: const Text('Email',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 12)),
                  ),
                  Container(
                    width: 260,
                    height: 30,
                    alignment: Alignment.center,
                    child: TextFormField(
                      onChanged: (newIndex) {
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      style: const TextStyle(fontSize: 20), 
                      onSaved: (String? value) {
                        // This optional block of code can be used to run
                        // code when the user saves the form.
                      },
                      validator: (String? value) {
                        return (value != null && value.contains('@'))
                            ? 'Do not use the @ char.'
                            : null;
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top:30.0),),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          spreadRadius: 0.01,
                          offset: Offset(
                            2,
                            2,
                          ),
                        )
                      ],
                    ),
                    width: 260,
                    height: 35,
                    child: FloatingActionButton.extended(
                    label: const Text('Send',
                        style: TextStyle(
                        color: Colors.black,
                        fontSize: 12)), // <-- Text
                    backgroundColor: Colors.white,
                    icon: const Icon( // <-- Icon
                      Icons.mail,
                      color: Color.fromARGB(255, 35, 35, 35),
                      size: 24.0,
                    ),
                    onPressed: () {},
                  ),
                  ),
                ]),
              ),
              const Padding(padding: EdgeInsets.only(top:60.0),),
              SizedBox(
                width: 1100,
                height: 90,
                child: Container(
                  margin: const EdgeInsets.only(right: 170, bottom: 20,left: 170),
                  decoration: const BoxDecoration(
                    color: Colors.white,
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
                      Flexible(fit: FlexFit.tight, child: SizedBox()),
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
                  ),
                ))
            ],
          ),
          )
          );
    }
}
Widget text(String title, Color color, double size) {
  return Text(title, style: TextStyle(color: color, fontSize: size));
}
