import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminThemes extends StatefulWidget {
  AdminThemes({super.key});

  @override
  State createState() => AdminThemesState();
}

class AdminThemesState extends mvc.StateMVC<AdminThemes> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Thumbnail',
      field: 'thumbnail',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Default',
      field: 'default',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Selectable',
      field: 'selectable',
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
        'thumbnail': PlutoCell(value: 'Australia Dollar'),
        'name': PlutoCell(value: 'AUD'),
        'default': PlutoCell(value: 'No'),
        'selectable': PlutoCell(value: 'Yes'),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Thumbnail', fields: ['thumbnail'], expandedColumn: true),
    PlutoColumnGroup(title: 'Name', fields: ['name'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Default', fields: ['default'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Selectable', fields: ['selectable'], expandedColumn: true),
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
            child: addroute == 'main' ? generalWidget() : addNewThemeWidget(),
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
            icon: const Icon(Icons.display_settings),
            pagename: 'Themes',
            button: {
              'flag': true,
              'buttoncolor': Colors.white,
              'icon': const Icon(
                Icons.add,
                color: Colors.black,
              ),
              'text': 'Add New Theme',
              'valueColor': Colors.black,
              'callback': () {
                addroute = 'addNew';
                setState(() {});
              },
              'size': Size(180, 50),
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
              onChanged: (PlutoGridOnChangedEvent event) {
                print(event);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget addNewThemeWidget() {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.display_settings),
            pagename: 'Themes › Add New Theme',
            button: {
              'flag': true,
              'buttoncolor': Colors.grey,
              'icon': const Icon(Icons.arrow_back),
              'text': 'Go Back',
              'callback': () {
                addroute = 'main';
                setState(() {});
              },
              'size': Size(120, 50),
            },
          ),
          textAndSelect('Default', 'Make it the default theme of the site'),
          textAndSelect('Selectable',
              'Make it enbaled so the user can translate the site to it'),
          titleAndsubtitleInput('Code', 30, 1,
              'Make it the selectable so users can change the theme. (You must have 2+ selectable themes)'),
          titleAndsubtitleInput('Name', 30, 1,
              'Theme name should not contain spaces or special characters. (Valid name examples: mytheme, material, custom_theme)'),
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
                Container(
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
                Container(
                  width: 400,
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
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
              child: Container(
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
                    style: TextStyle(fontSize: 13)),
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
