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
  SearchScreen({Key? key, required this.onChange})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  Function onChange;

  @override
  State createState() => SearchScreenState();
}

// ignore: must_be_immutable
class SearchScreenState extends mvc.StateMVC<SearchScreen> {
  bool showMenu = false;
  late PeopleController con;
  //route variable
  Map isFriendRequest = {};
  String tabName = 'Discover';
  Color color = Color.fromRGBO(230, 236, 245, 1);
  List gender = [
    {'value': 'Any', 'title': 'Any'},
    {'value': 'Male', 'title': 'male'},
    {'value': 'Female', 'title': 'female'},
    {'value': 'Other', 'title': 'other'},
  ];
  List relationShip = [
    {'value': 'Any', 'title': 'Any'},
    {'value': 'Single', 'title': 'Single'},
    {'value': 'In a relationship', 'title': 'In a relationship'},
    {'value': 'Married', 'title': 'Married'},
    {'value': "It's complicated", 'title': "It's complicated"},
    {'value': "Separated", 'title': "Separated"},
    {'value': "Divorced", 'title': "Divorced"},
    {'value': "Widowed", 'title': "Widowed"},
  ];
  List onlineStatus = [
    {'value': 'Any', 'title': 'Any'},
    {'value': 'Online', 'title': 'Online'},
    {'value': 'Offline', 'title': 'Offline'},
  ];
  List religion = [
    {'value': 'Any', 'title': 'Any'},
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
          ? SizeConfig(context).screenWidth - 60
          : SizeConfig(context).screenWidth * 0.3 - 90,
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(children: [
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
        Padding(
          padding: EdgeInsets.only(top: 20),
        ),
        customInput(title: 'Hometown', onChange: (value) {}),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        customInput(
          title: 'Current place',
          onChange: (value) {},
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        customInput(title: 'Keyword', onChange: (value) {}),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        customDropDownButton(
            title: 'Gender',
            item: gender,
            onChange: (value) {},
            context: context),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        customDropDownButton(
            title: 'Relationship',
            item: relationShip,
            onChange: (value) {},
            context: context),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        customDropDownButton(
            title: 'Online Status',
            item: onlineStatus,
            onChange: (value) {},
            context: context),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        customDropDownButton(
            title: 'Religion',
            item: religion,
            onChange: (value) {},
            context: context),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        ElevatedButton(
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
            onPressed: () {
              () => {};
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
            ))
      ]),
    );
  }

  Widget customInput({title, onChange}) {
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
            onChanged: (value) {
              onChange(value);
              geoLocator(value);
            },
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

  void geoLocator(value) async {
    final sessionToken = Uuid().v4();
    final client = Client();

    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&types=address&language=${Localizations.localeOf(context).languageCode}&components=country:ch&key=${Helper.apiKey}&sessiontoken=$sessionToken';
    final response = await client.get(Uri.parse(request));
    var res = jsonDecode(response.body);
    print(res['predictions']);
  }
}
