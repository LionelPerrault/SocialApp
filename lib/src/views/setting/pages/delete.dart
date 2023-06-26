import 'package:flutter/material.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import 'package:shnatter/src/widget/startedInput.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

class SettingDeleteScreen extends StatefulWidget {
  SettingDeleteScreen({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  late UserController con;
  Function routerChange;
  @override
  State createState() => SettingDeleteScreenState();
}

// ignore: must_be_immutable
class SettingDeleteScreenState extends mvc.StateMVC<SettingDeleteScreen> {
  // ignore: non_constant_identifier_names
  var setting_security = {};
  late UserController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as UserController;
    super.initState();
  }

  deleteAccount(context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const SizedBox(),
        content: AlertYesNoWidget(
            yesFunc: () async {
              con.deleteUserAccount(context);
              Navigator.of(context).pop(true);
            },
            noFunc: () {
              Navigator.of(context).pop(true);
            },
            header: 'Delete account',
            text: 'Do you want to delete your account?',
            progress: false),
      ),
    );
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
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.black, size: 20.0),
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
                            'Delete account',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 130,
                  ),
                  padding: const EdgeInsets.all(25),
                  width: 900,
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 65,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 252, 124, 95),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Row(
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(left: 30)),
                                    const Icon(
                                      Icons.warning_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    SizedBox(
                                        width: SizeConfig(context).screenWidth *
                                            0.5,
                                        child: const Text(
                                          'Once you delete your account you will no longer can access it again',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11),
                                        )),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                  width: 145,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(3),
                                        backgroundColor: const Color.fromARGB(
                                            255, 245, 54, 92),
                                        // elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3.0)),
                                        minimumSize: const Size(140, 50),
                                        maximumSize: const Size(140, 50),
                                      ),
                                      onPressed: () {
                                        deleteAccount(context);
                                      },
                                      child: con.isProfileChange
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.delete),
                                                Text('Delete My Account',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ))),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        )),
      ),
    );
  }

  Widget input({label, onchange, obscureText = false, validator}) {
    return SizedBox(
      height: 28,
      child: StartedInput(
        validator: (val) async {
          validator(val);
        },
        obscureText: obscureText,
        onChange: (val) async {
          onchange(val);
        },
      ),
    );
  }
}
