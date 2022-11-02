
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

import '../controllers/HomeController.dart';
import '../widget/white_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
    LoginScreen({Key? key})
        : con = HomeController(),
          super(key: key);
    final HomeController con;

    @override
    State createState() => LoginScreenState();
}

class LoginScreenState extends mvc.StateMVC<LoginScreen> {
    
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
          body: ListView(
            children:[
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Container(
                      width: 340,
                      height: 500,
                      margin: const EdgeInsets.only(left: 100,right: 50),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      child: ListView(
                        children: <Widget>[
                          Container(
                            width: 445,
                            height: 60,
                            margin: const EdgeInsets.only(top: 80.0),
                            color: Color.fromARGB(255, 11, 35, 45),
                            child: Row(
                              children: <Widget>[
                              Padding(padding: EdgeInsets.only(left:45.0),),
                              Text('Login',
                                      style: const TextStyle(
                                      color: Color.fromARGB(255, 238, 238, 238),
                                      fontSize: 40,
                                      fontWeight: FontWeight.w300
                                  )),
                              ]),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30.0),
                            child: Row(
                              children:[
                                Padding(padding: EdgeInsets.only(left:45.0),),
                                SvgPicture.network('https://test.shnatter.com/content/themes/default/images/shnatter-logo-login.svg')]),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 260,
                                  height: 30,
                                  child: TextFormField(
                                    onChanged: (newIndex) {
                                      con.setState(() => con.email=newIndex);
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: Icon(
                                        Icons.person_outline_rounded,
                                        color: Color.fromARGB(255, 35, 35, 35),
                                      ),
                                      hintText: 'Email or Username',
                                    ),
                                    style: TextStyle(fontSize: 12), 
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
                                Padding(padding: EdgeInsets.only(top:10.0),),
                                Container(
                                  width: 260,
                                  height: 30,
                                  child: TextFormField(
                                    obscureText: true,
                                    onChanged: (newIndex) {
                                      con.setState(() => con.email=newIndex);
                                    },

                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                        const BorderSide(color: Color.fromARGB(255, 54, 54, 54), width: 1.0),
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: Icon(
                                        Icons.key,
                                        color: Color.fromARGB(255, 35, 35, 35),
                                      ),
                                      hintText: 'Password',
                                    ),
                                    style: TextStyle(fontSize: 12), 
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
                                )
                                
                              ]),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.blue,
                                fillColor: MaterialStateProperty.resolveWith(getColor),
                                value: check1,
                                shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0))), //rounded checkbox
                                onChanged: (value) {
                                  setState(() {
                                    check1 = check1 ? false : true;
                                  });
                                },
                              ),
                              Text('Remember me',
                                      style: const TextStyle(
                                      color: Color.fromARGB(255, 150, 150, 150),
                                      fontSize: 12)),
                              Padding(padding: EdgeInsets.only(left:60.0),),
                              Text('Forgotten password?',
                                      style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 12)),
                              ]),
                          ),
                          Container(
                            width: 260,
                            margin: const EdgeInsets.only(top: 10.0),
                            padding: const EdgeInsets.only(left: 40.0,right: 40),
                            child: WhiteButton(
                                    buttonName:  "Login",
                                    onPressed: () =>{
                                      con.changeLaguage("en")
                                    },
                                    miniumSize: const Size(260, 35),
                                    ),
                                  ),
                          Container(
                            margin: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                    Text('Not Registered?',
                                            style: const TextStyle(
                                            color: Color.fromARGB(255, 150, 150, 150),
                                            fontSize: 12,)),
                                    Text('Create an account',
                                            style: const TextStyle(
                                            color: Color.fromARGB(255, 255, 255, 255),
                                            fontSize: 12,)),
                              ]) 
                          ),
                        ],
                      ),
                    ),
                ),
                Align(
                  child: Container(
                    width: 850,
                    height: 74,
                    margin: const EdgeInsets.only(top:50, bottom: 20.0,left: 100,right: 100),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Row(children: [
                      Padding(padding: EdgeInsets.only(left:10.0),),
                      Text('© 2022 Shnatter',
                          style: const TextStyle(
                          color: Color.fromARGB(255, 150, 150, 150),
                          fontSize: 12)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end, //change here don't //worked
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('About',
                          style: const TextStyle(
                          color: Color.fromARGB(255, 150, 150, 150),
                          fontSize: 12)),
                          Padding(padding: EdgeInsets.only(left:5.0),),
                          Text('Terms',
                              style: const TextStyle(
                              color: Color.fromARGB(255, 150, 150, 150),
                              fontSize: 12)),
                          Padding(padding: EdgeInsets.only(left:5.0),),
                          Text('Privacy',
                              style: const TextStyle(
                              color: Color.fromARGB(255, 150, 150, 150),
                              fontSize: 12)),
                          Padding(padding: EdgeInsets.only(left:5.0),),
                          Text('Contact Us',
                              style: const TextStyle(
                              color: Color.fromARGB(255, 150, 150, 150),
                              fontSize: 12)),
                          Padding(padding: EdgeInsets.only(left:5.0),),
                          Text('Directory',
                              style: const TextStyle(
                              color: Color.fromARGB(255, 150, 150, 150),
                              fontSize: 12)),
                        ],
                      )
                    ]),
                  ),
                )
            ]
          )
          );
    }
}
