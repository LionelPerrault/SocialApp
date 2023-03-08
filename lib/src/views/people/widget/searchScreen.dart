// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:uuid/uuid.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key, required this.onClick, required this.isModal})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  Function onClick;
  bool isModal;
  @override
  State createState() => SearchScreenState();
}

// ignore: must_be_immutable
class SearchScreenState extends mvc.StateMVC<SearchScreen> {
  bool showMenu = false;
  late PeopleController con;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PeopleController;
  }

  //route variable
  Map isFriendRequest = {};
  final TextEditingController hometownController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController currentController = TextEditingController();
  final TextEditingController keydownController = TextEditingController();
  List location = [];
  String tabName = 'Discover';
  String isShowLocation = '';
  String hometownText = '';
  String currentText = '';
  Map search = {};
  Color color = Color.fromRGBO(230, 236, 245, 1);
  List gender = [
    {'title': 'Any', 'value': 'any'},
    {'title': 'Male', 'value': 'male'},
    {'title': 'Female', 'value': 'female'},
    {'title': 'Other', 'value': 'other'},
  ];
  List relationShip = [
    {'value': 'any', 'title': 'Any'},
    {'value': 'Single', 'title': 'Single'},
    {'value': 'In a relationship', 'title': 'In a relationship'},
    {'value': 'Married', 'title': 'Married'},
    {'value': "It's complicated", 'title': "It's complicated"},
    {'value': "Separated", 'title': "Separated"},
    {'value': "Divorced", 'title': "Divorced"},
    {'value': "Widowed", 'title': "Widowed"},
  ];
  List onlineStatus = [
    {'value': 'Any', 'title': 'any'},
    {'value': 'Online', 'title': 'Online'},
    {'value': 'Offline', 'title': 'Offline'},
  ];
  List religion = [
    {'value': 'Any', 'title': 'any'},
    {'value': 'Jewish', 'title': 'Jewish'},
    {'value': 'Lizard', 'title': 'Lizard'},
    {'value': 'world', 'title': 'world'},
    {
      'value': 'Serbian Christian Orthodox',
      'title': 'Serbian Christian Orthodox'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig(context).screenWidth < 900
          ? SizeConfig(context).screenWidth - 90
          : SizeConfig(context).screenWidth * 0.3 - 90,
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Stack(children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Color.fromRGBO(246, 249, 252, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3), topRight: Radius.circular(3))),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Padding(padding: EdgeInsets.only(left: 10)),
                Icon(
                  Icons.search,
                  size: 15,
                ),
                Text('Search')
              ]),
        ),
        Container(
          margin: EdgeInsets.only(top: 65),
          child: customInput(
              title: 'UserName',
              controller: userNameController,
              onChange: (value) {
                search['userName'] = value;
                if (value == '') search.remove('userName');
              }),
        ),
        Container(
          margin: EdgeInsets.only(top: 65 * 2),
          child: customInput(
              title: 'Hometown',
              controller: hometownController,
              onChange: (value) {
                //search = {'hometown': value};
                geoLocator(
                  value,
                  'hometown',
                );
              }),
        ),
        Container(
          margin: EdgeInsets.only(top: 65 * 3),
          child: customInput(
            title: 'Current place',
            controller: currentController,
            onChange: (value) {
              //search = {'current': value};
              geoLocator(value, 'current');
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 65 * 4),
          child: customInput(
              title: 'Keyword',
              onChange: (value) {
                search['keyword'] = value;
                if (value == '') search.remove('keyword');
              }),
        ),
        Container(
          margin: EdgeInsets.only(top: 65 * 5),
          child: customDropDownButton(
              title: 'Gender',
              item: gender,
              onChange: (value) {
                if (value == 'any')
                  search.remove('sex');
                else
                  search['sex'] = value;
              },
              context: context),
        ),
        Container(
          margin: EdgeInsets.only(top: 65 * 6),
          child: customDropDownButton(
              title: 'Relationship',
              item: relationShip,
              onChange: (value) {
                if (value == 'any')
                  search.remove('relationship');
                else
                  search['relationship'] = value;
              },
              context: context),
        ),
        Container(
          margin: EdgeInsets.only(top: 65 * 7),
          child: customDropDownButton(
              title: 'Online Status',
              item: onlineStatus,
              onChange: (value) {
                if (value == 'any')
                  search.remove('checkonline');
                else
                  search['checkonline'] = value;
              },
              context: context),
        ),
        Container(
          margin: EdgeInsets.only(top: 65 * 8),
          child: customDropDownButton(
              title: 'Religion',
              item: religion,
              onChange: (value) {
                if (value == 'any')
                  search.remove('religion');
                else
                  search['religion'] = value;
              },
              context: context),
        ),
        Container(
          margin: EdgeInsets.only(top: 65 * 9),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                minimumSize: Size(
                    SizeConfig(context).screenWidth < 900
                        ? SizeConfig(context).screenWidth - 60
                        : SizeConfig(context).screenWidth * 0.3 - 90,
                    50),
                maximumSize: Size(
                    SizeConfig(context).screenWidth < 900
                        ? SizeConfig(context).screenWidth - 60
                        : SizeConfig(context).screenWidth * 0.3 - 90,
                    50),
              ),
              onPressed: () async {
                widget.onClick(search);
                if (widget.isModal) Navigator.of(context).pop(true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 16,
                  ),
                  Padding(padding: EdgeInsets.only(left: 3)),
                  Text('Search',
                      style: TextStyle(
                          color: Color.fromARGB(255, 33, 37, 41),
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold)),
                ],
              )),
        ),
        isShowLocation == ''
            ? Container()
            : Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Color.fromRGBO(245, 245, 245, 1), width: 0.6)),
                width: SizeConfig(context).screenWidth < 900
                    ? SizeConfig(context).screenWidth - 59
                    : SizeConfig(context).screenWidth * 0.3 - 90,
                margin: EdgeInsets.only(
                    top: isShowLocation == 'hometown' ? 115 : 180),
                child: Column(
                    children: location
                        .map((e) => MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: InkWell(
                                onTap: () {
                                  if (isShowLocation == 'hometown') {
                                    hometownController.text = e['data'];
                                  } else {
                                    currentController.text = e['data'];
                                  }
                                  isShowLocation = '';
                                  search = {isShowLocation: e['value']};
                                  setState(() {});
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: Text(
                                        e['data'],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 1,
                                      color: Color.fromRGBO(245, 245, 245, 1),
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList()),
              )
      ]),
    );
  }

  Widget customInput({title, onChange, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              color: Color.fromRGBO(82, 95, 127, 1),
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 40,
          child: TextField(
            controller: controller,
            onChanged: onChange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget customDropDownButton({title, item = const [], onChange, context}) {
    List items = item;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyle(
            color: Color.fromRGBO(82, 95, 127, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
      Padding(padding: EdgeInsets.only(top: 2)),
      Container(
          height: 40,
          width: SizeConfig(context).screenWidth < 900
              ? SizeConfig(context).screenWidth - 60
              : SizeConfig(context).screenWidth * 0.3 - 90,
          child: DropdownButtonFormField(
            value: items[0]['value'],
            items: items
                .map((e) => DropdownMenuItem(
                    value: e['value'], child: Text(e['title'])))
                .toList(),
            onChanged: onChange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
            icon: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.arrow_drop_down)),
            iconEnabledColor: Colors.grey, //Icon color

            style: const TextStyle(
              color: Colors.grey, //Font color
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            isDense: true,
          ))
    ]);
  }

  void geoLocator(value, what) async {
    final sessionToken = Uuid().v4();
    final client = Client();

    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&types=address&language=en&key=${Helper.apiKey}&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));
    var res = jsonDecode(response.body);
    var loc = [];
    res['predictions'].forEach((elem) {
      var ss = elem['description'].replaceAll(' ', '');
      var str = ss.split(',');
      var s = '';
      for (int i = str.length - 1; i >= 0; i--) {
        s += i == 0
            ? ' ${str[i]}'
            : i == str.length - 1
                ? '${str[i]}'
                : ' ${str[i]} >';
      }
      loc.add({'value': elem['description'], 'data': s});
    });
    location = loc;
    if (location.isEmpty) {
      isShowLocation = what;
      setState(() {});
    } else {
      isShowLocation = what;
      setState(() {});
    }
  }
}
