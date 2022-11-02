
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import '../controllers/HomeController.dart';
import '../widget/white_button.dart';
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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
    void initState() {
      add(widget.con);
      con = controller as HomeController;
      super.initState();
    }

    late HomeController con;
    @override
    Widget build(BuildContext context) {
      
      Color getColor(Set<MaterialState> states) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
        };
        if (states.any(interactiveStates.contains)) {
          return Colors.blue;
        }
        return Colors.blue;
      }
      return Scaffold(
          body: Container(alignment: Alignment.center,
            child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top:60.0),),
              Container(
                color: Colors.blue,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left:45.0),),
                    Container(
                      width: 200,
                      height: 200,
                      child: SvgPicture.network('https://test.shnatter.com/content/themes/default/images/headers/undraw_message_sent_1030.svg'),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.only(left:60.0),),
                            Text('Reset Password',
                              style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22)),
                            Text('Enter the email address you signed up with and we\'ll email you a reset link',
                              style: const TextStyle(
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
                      boxShadow: [
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
                  Padding(padding: EdgeInsets.only(top: 35),),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(left: 40.0),
                    child: Text('Email',
                        style: const TextStyle(
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
                      style: TextStyle(fontSize: 20), 
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
                  Padding(padding: EdgeInsets.only(top:30.0),),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
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
                    label: Text('Send',
                        style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12)), // <-- Text
                    backgroundColor: Colors.white,
                    icon: Icon( // <-- Icon
                      Icons.mail,
                      color: Color.fromARGB(255, 35, 35, 35),
                      size: 24.0,
                    ),
                    onPressed: () {},
                  ),
                  ),
                ]),
              )
            ],
          ),
          )
          );
    }
}
