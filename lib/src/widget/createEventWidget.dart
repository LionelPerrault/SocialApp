import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';

import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import 'package:shnatter/src/widget/interests.dart';

// ignore: must_be_immutable
class CreateEventModal extends StatefulWidget {
  BuildContext context;
  late PostController postCon;
  CreateEventModal(
      {Key? key, required this.context, required this.routerChange})
      : postCon = PostController(),
        super(key: key);
  Function routerChange;
  @override
  State createState() => CreateEventModalState();
}

class CreateEventModalState extends mvc.StateMVC<CreateEventModal> {
  bool isSound = false;
  late PostController postCon;
  Map<String, dynamic> eventInfo = {
    'eventPrivacy': 'public',
    'eventAbout': '',
    'eventInterests': [],
  };
  var privacy = 'public';
  var interest = 'none';
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  bool footerBtnState = false;
  bool payLoading = false;
  // bool loading = false;
  @override
  void initState() {
    add(widget.postCon);
    postCon = controller as PostController;
    super.initState();
  }

  getTokenBudget() async {
    var adminSnap = await Helper.systemSnap.doc('config').get();
    var price = adminSnap.data()!['priceCreatingEvent'];
    var snapshot = await FirebaseFirestore.instance
        .collection(Helper.adminPanel)
        .doc(Helper.backPaymail)
        .get();
    var paymail = snapshot.data()!['address'];
    setState(() {});
    if (price == '0') {
      await postCon.createEvent(context, eventInfo).then((value) => {
            footerBtnState = false,
            setState(
              () => {},
            ),
            Navigator.of(context).pop(true),
            Helper.showToast(value['msg']),
            if (value['result'] == true)
              {
                widget.routerChange({
                  'router': RouteNames.events,
                  'subRouter': value['value'],
                })
              }
          });
      setState(() {});
    } else {
      footerBtnState = false;
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: const SizedBox(),
          content: AlertYesNoWidget(
              yesFunc: () async {
                payLoading = true;
                setState(() {});
                await UserController()
                    .payShnToken(paymail, price, 'Pay for creating event')
                    .then(
                      (value) async => {
                        if (value)
                          {
                            payLoading = false,
                            setState(() {}),
                            Navigator.of(dialogContext).pop(true),
                            // loading = true,
                            setState(() {}),
                            await postCon
                                .createEvent(context, eventInfo)
                                .then((value) {
                              footerBtnState = false;
                              setState(() => {});
                              Navigator.of(context).pop(true);
                              // loading = true;
                              setState(() {});
                              Helper.showToast(value['msg']);
                              if (value['result'] == true) {
                                widget.routerChange({
                                  'router': RouteNames.events,
                                  'subRouter': value['value'],
                                });
                              }
                            }),
                            setState(() {}),
                            // loading = false,
                            // setState(() {}),
                          }
                      },
                    );
              },
              noFunc: () {
                Navigator.of(context).pop(true);
                footerBtnState = false;
                setState(() {});
              },
              header: 'Costs for creating page',
              text:
                  'By paying the fee of $price tokens, the event will be published.',
              progress: payLoading),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig(context).screenHeight - 119,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Divider(
                  height: 0,
                  indent: 0,
                  endIndent: 0,
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customInput(
                      title: 'Name Your Event',
                      onChange: (value) async {
                        eventInfo['eventName'] = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customInput(
                      title: 'Location',
                      onChange: (value) async {
                        eventInfo['eventLocation'] = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customDateInput(
                      title: 'Start Date',
                      controller: startDateController,
                      onChange: (value) async {},
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(
                              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                          //You can format date as per your need

                          setState(() {
                            startDateController.text = formattedDate;
                            eventInfo['eventStartDate'] = formattedDate;
                          });
                        } else {}
                      },
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customDateInput(
                      title: 'End Date',
                      controller: endDateController,
                      onChange: (value) async {},
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(), //get today's date
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(
                              pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                          //You can format date as per your need

                          setState(() {
                            eventInfo['eventEndDate'] = formattedDate;
                            endDateController.text = formattedDate;
                          });
                        } else {}
                      },
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Text('Select Privacy',
                            style: TextStyle(
                                color: Color.fromARGB(255, 82, 95, 127),
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 400,
                        height: 40,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 17, 205, 239),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 17, 205, 239),
                                  width:
                                      0.1), //bordrder raiuds of dropdown button
                            ),
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 7, left: 15),
                                child: DropdownButton(
                                  value: privacy,
                                  items: [
                                    DropdownMenuItem(
                                      value: "public",
                                      child: Row(children: const [
                                        Icon(
                                          Icons.language,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 5)),
                                        Text(
                                          "Public",
                                          style: TextStyle(fontSize: 13),
                                        )
                                      ]),
                                    ),
                                    DropdownMenuItem(
                                      value: "closed",
                                      child: Row(children: const [
                                        Icon(
                                          Icons.groups,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 5)),
                                        Text(
                                          "Closed",
                                          style: TextStyle(fontSize: 13),
                                        )
                                      ]),
                                    ),
                                    DropdownMenuItem(
                                      value: "security",
                                      child: Row(children: const [
                                        Icon(
                                          Icons.lock_outline,
                                          color: Colors.black,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 5)),
                                        Text(
                                          "Security",
                                          style: TextStyle(fontSize: 13),
                                        )
                                      ]),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    //get value when changed
                                    eventInfo['eventPrivacy'] = value;
                                    privacy = value.toString();
                                    print(privacy);
                                    // click(value);
                                    setState(() {});
                                  },
                                  icon: const Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Icon(Icons.arrow_drop_down)),
                                  iconEnabledColor: Colors.white, //Icon color
                                  style: const TextStyle(
                                    color: Colors.black, //Font color
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  dropdownColor: Colors.white,
                                  underline: Container(), //remove underline
                                  isExpanded: true,
                                  isDense: true,
                                ))),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titleAndsubtitleInput('About', 70, 5, (value) {
                                  eventInfo['eventAbout'] = value;
                                  setState(() {});
                                }),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                SizedBox(
                  width: 400,
                  child: InterestsWidget(
                    context: context,
                    sendUpdate: (value) {
                      eventInfo['eventInterests'] = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 400,
          margin: const EdgeInsets.only(right: 20, bottom: 10),
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
                  minimumSize: const Size(100, 50),
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
                  minimumSize: const Size(100, 50),
                ),
                onPressed: () {
                  footerBtnState = true;
                  setState(() {});
                  getTokenBudget();
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
        )
      ],
    );
  }
}

Widget customInput({title, onChange, controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
            color: Color.fromRGBO(82, 95, 127, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
      const Padding(padding: EdgeInsets.only(top: 2)),
      SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          onChanged: onChange,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(top: 10, left: 10),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 1.0),
            ),
          ),
        ),
      )
    ],
  );
}

Widget customDateInput({title, onChange, controller, onTap}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
            color: Color.fromRGBO(82, 95, 127, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
      const Padding(padding: EdgeInsets.only(top: 2)),
      SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          onChanged: onChange,
          onTap: () async {
            onTap();
          },
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(top: 10, left: 10),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
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
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 85, 95, 127)),
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                width: 400,
                height: double.parse(height.toString()),
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
