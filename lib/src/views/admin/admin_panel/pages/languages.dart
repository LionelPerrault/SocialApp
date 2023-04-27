import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminLanguages extends StatefulWidget {
  AdminLanguages({super.key});

  @override
  State createState() => AdminLanguagesState();
}

class AdminLanguagesState extends mvc.StateMVC<AdminLanguages> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Title',
      field: 'title',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Code',
      field: 'code',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Order',
      field: 'order',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Default',
      field: 'default',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Enabled',
      field: 'enabled',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Actions',
      field: 'actions',
      type: PlutoColumnType.text(),
    ),
  ];

  final List<PlutoRow> rows = [
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'title': PlutoCell(value: 'Australia Dollar'),
        'code': PlutoCell(value: 'AUD'),
        'order': PlutoCell(value: '\$'),
        'default': PlutoCell(value: 'No'),
        'enabled': PlutoCell(value: 'Yes'),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Title', fields: ['title'], expandedColumn: true),
    PlutoColumnGroup(title: 'Code', fields: ['code'], expandedColumn: true),
    PlutoColumnGroup(title: 'Order', fields: ['order'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Default', fields: ['default'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Enabled', fields: ['enabled'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Actions', fields: ['actions'], expandedColumn: true),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;
  @override
  void initState() {
    super.initState();
  }

  bool check1 = false;
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  double fontSize = 14;
  var addroute = 'main';
  List direction = [
    {'value': 'ltr', 'title': 'LTR'},
    {'value': 'rtl', 'title': 'RTL'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.75
                : SizeConfig(context).screenWidth,
            child:
                addroute == 'main' ? generalWidget() : addNewCurrencyWidget(),
          ),
        ],
      ),
    );
  }

  Widget generalWidget() {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.language),
            pagename: 'Languages',
            button: {
              'flag': true,
              'buttoncolor': Colors.white,
              'icon': const Icon(
                Icons.add,
                color: Colors.black,
              ),
              'text': 'Add New Language',
              'valueColor': Colors.black,
              'callback': () {
                addroute = 'addNew';
                setState(() {});
              },
              'size': const Size(180, 50),
            },
          ),
          Container(
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.75
                : SizeConfig(context).screenWidth,
            height: SizeConfig(context).screenHeight - SizeConfig.navbarHeight,
            padding: const EdgeInsets.all(15),
            child: PlutoGrid(
              configuration: const PlutoGridConfiguration(
                columnSize: PlutoGridColumnSizeConfig(),
              ),
              columns: columns,
              rows: rows,
              columnGroups: columnGroups,
              onLoaded: (PlutoGridOnLoadedEvent event) {
                stateManager = event.stateManager;
                stateManager.setShowColumnFilter(true);
              },
              onChanged: (PlutoGridOnChangedEvent event) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget addNewCurrencyWidget() {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.language),
            pagename: 'Languages › Add New Language',
            button: {
              'flag': true,
              'buttoncolor': Colors.grey,
              'icon': const Icon(Icons.arrow_back),
              'text': 'Go Back',
              'callback': () {
                addroute = 'main';
                setState(() {});
              },
              'size': const Size(120, 50),
            },
          ),
          textAndSelect('Default', 'Make it the default language of the site'),
          textAndSelect('Enabled',
              'Make it enbaled so the user can translate the site to it'),
          titleAndsubtitleInput('Code', 30, 1,
              'Language country_code, For Example: en_us, ar_sa or fr_fr'),
          titleAndsubtitleInput(
              'Native Name', 30, 1, 'The native name of this language'),
          titleAndUpload('Flag'),
          customDropDownButton(
              title: 'Direction',
              item: direction,
              onChange: (value) {},
              context: context,
              subTitle:
                  'The direction of this language \'Left To Right\' or \'Right To Left\''),
          titleAndsubtitleInput('Order', 30, 1, ''),
          footer(),
        ],
      ),
    );
  }

  Widget titleAndsubtitleInput(title, height, line, subtitle) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 85, 95, 127)),
            ),
          ),
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 400,
                  height: height,
                  child: TextField(
                    maxLines: line,
                    minLines: line,
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, left: 10),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customDropDownButton(
      {title, item = const [], onChange, context, subTitle}) {
    List items = item;
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(
                  color: Color.fromRGBO(82, 95, 127, 1),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  width: 400,
                  child: DropdownButtonFormField(
                    value: items[0]['value'],
                    items: items
                        .map((e) => DropdownMenuItem(
                            value: e['value'], child: Text(e['title'])))
                        .toList(),
                    onChanged: onChange,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, left: 10),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.0),
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
                  ),
                ),
                Text(
                  subTitle,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget textAndSelect(title, content) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: SizedBox(
            width: SizeConfig(context).screenWidth * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: fontColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(content,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
          )),
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 20,
              child: Transform.scale(
                scaleX: 1,
                scaleY: 1,
                child: CupertinoSwitch(
                  thumbColor: Colors.white,
                  activeColor: Colors.black,
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleAndUpload(title) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: fontColor, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Flexible(
            fit: FlexFit.tight,
            child: SizedBox(),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 70, left: 70),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(4),
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      minimumSize: const Size(30, 30),
                      maximumSize: const Size(30, 30),
                    ),
                    onPressed: () {},
                    child: const Icon(Icons.camera_enhance_rounded,
                        color: Colors.black, size: 16.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget footer() {
    return Container(
        height: 80,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(240, 240, 240, 1),
            border: Border(top: BorderSide(width: 0.5, color: Colors.grey))),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0)),
            minimumSize: const Size(150, 50),
            maximumSize: const Size(150, 50),
          ),
          onPressed: () {
            () => {};
          },
          child: const Text('Save Changes',
              style: TextStyle(
                  color: Color.fromARGB(255, 33, 37, 41),
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold)),
        ));
  }
}
