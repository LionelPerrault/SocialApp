import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminListForums extends StatefulWidget {
  AdminListForums({super.key});

  @override
  State createState() => AdminListForumsState();
}

class AdminListForumsState extends mvc.StateMVC<AdminListForums> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Title',
      field: 'title',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Description',
      field: 'description',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Threads',
      field: 'threads',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Order',
      field: 'order',
      type: PlutoColumnType.number(),
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
        'title': PlutoCell(value: 'The 5 Country Commitee'),
        'description': PlutoCell(value: 'Directly problem'),
        'threads': PlutoCell(value: 'Environment Problem'),
        'order': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'fix'),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Title', fields: ['title'], expandedColumn: true),
    PlutoColumnGroup(title: 'Description', fields: ['description'], expandedColumn: true),
    PlutoColumnGroup(title: 'Threads', fields: ['threads'], expandedColumn: true),
    PlutoColumnGroup(title: 'Order', fields: ['order'], expandedColumn: true),
    PlutoColumnGroup(title: 'Actions', fields: ['actions'], expandedColumn: true),

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
            child:
                addroute == 'main' ? generalWidget() : addNewForumWidget(),
          ),
        ],
      ),
    );
  }

  @override

  Widget generalWidget() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.forum),
            pagename: 'Forums',
            button: {
              'flag': true,
              'buttoncolor': Colors.white,
              'icon': const Icon(
                Icons.add,
                color: Colors.black,
              ),
              'text': 'Add New Game',
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

    Widget addNewForumWidget() {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.forum),
            pagename: 'Forums › Add New Forum',
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
          titleAndsubtitleInput('Name', 40, 1,
            ''  ),
          titleAndsubtitleInput('Description', 80, 4,
            '' ),
          titleAndsubtitleInput('Order', 40, 1,
            '' ),
          footer(),
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
          child: 
            SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
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
        border: Border(top: BorderSide(width: 0.5, color: Colors.grey))
      ),
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
            fontWeight: FontWeight.bold
          )
        ),
      )
    );
  }
}


