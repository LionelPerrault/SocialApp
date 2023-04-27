import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminListThreads extends StatefulWidget {
  AdminListThreads({super.key});

  @override
  State createState() => AdminListThreadsState();
}

class AdminListThreadsState extends mvc.StateMVC<AdminListThreads> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Author',
      field: 'author',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Title',
      field: 'title',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Time',
      field: 'time',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Link',
      field: 'link',
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
        'author': PlutoCell(value: 'Krystiyan'),
        'title': PlutoCell(value: 'Environment Problem'),
        'time': PlutoCell(value: '8:00/12:00'),
        'link': PlutoCell(value: ''),
        'actions': PlutoCell(value: 'fix'),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'ID', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Author', fields: ['author'], expandedColumn: true),
    PlutoColumnGroup(title: 'Title', fields: ['title'], expandedColumn: true),
    PlutoColumnGroup(title: 'Time', fields: ['time'], expandedColumn: true),
    PlutoColumnGroup(title: 'Link', fields: ['link'], expandedColumn: true),
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

  String? selectedValue;

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
                ? SizeConfig(context).screenWidth * 0.85
                : SizeConfig(context).screenWidth,
            child: addroute == 'main' ? generalWidget() : threadFindWidget(),
          ),
        ],
      ),
    );
  }

  @override
  Widget generalWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminSettingHeader(
          icon: const Icon(Icons.forum),
          pagename: 'Forums › Threads',
          button: {
            'flag': true,
            'buttoncolor': Colors.white,
            'icon': const Icon(
              Icons.search,
              color: Colors.black,
            ),
            'text': 'Search',
            'valueColor': Colors.black,
            'callback': () {
              addroute = 'addNew';
              setState(() {});
            },
            'size': const Size(180, 50),
          },
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(3),
                backgroundColor: Colors.white,
                // elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                maximumSize: const Size(100, 50),
                minimumSize: const Size(100, 50)),
            onPressed: () {
              setState(() {});
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                Text('Search',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))
              ],
            )),
        Container(
          width: SizeConfig(context).screenWidth > 800
              ? SizeConfig(context).screenWidth * 0.85
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
    );
  }

  Widget threadFindWidget() {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.forum),
            pagename: 'Forums › Threads › Find',
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
          Container(
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.85
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

  Widget titleAndsubtitleInput(title, height, line, subtitle) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
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
                  color: Color.fromARGB(255, 3, 3, 3)),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 500,
                    height: height,
                    child: TextField(
                      maxLines: line,
                      minLines: line,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
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
