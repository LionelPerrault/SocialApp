import 'package:flutter/material.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
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
    return Container(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            SettingHeader(
              routerChange: widget.routerChange,
              icon: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 244, 67, 54),
              ),
              pagename: 'Delete Account',
              button: const {'flag': false},
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Container(
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            children: [
                              const Padding(padding: EdgeInsets.only(left: 30)),
                              const Icon(
                                Icons.warning_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              SizedBox(
                                  width: SizeConfig(context).screenWidth * 0.5,
                                  child: const Text(
                                    'Once you delete your account you will no longer can access it again',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11),
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
                                  backgroundColor:
                                      const Color.fromARGB(255, 245, 54, 92),
                                  // elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0)),
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
                                        child: CircularProgressIndicator(),
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
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ))),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
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
