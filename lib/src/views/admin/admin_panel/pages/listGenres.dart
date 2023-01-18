import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminListGenres extends StatefulWidget {
  AdminListGenres({super.key});

  @override
  State createState() => AdminListGenresState();
}

class AdminListGenresState extends mvc.StateMVC<AdminListGenres> {
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
        'id': PlutoCell(value: 1),
        'title': PlutoCell(value: "Action"),
        'order': PlutoCell(value: 1),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 2),
        'title': PlutoCell(value: "Adventure"),
        'order': PlutoCell(value: 2),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 3),
        'title': PlutoCell(value: "Animation"),
        'order': PlutoCell(value: 3),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 4),
        'title': PlutoCell(value: "Comedy"),
        'order': PlutoCell(value: 4),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 5),
        'title': PlutoCell(value: "Crime"),
        'order': PlutoCell(value: 5),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 6),
        'title': PlutoCell(value: "Documentary"),
        'order': PlutoCell(value: 6),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 7),
        'title': PlutoCell(value: "Drama"),
        'order': PlutoCell(value: 7),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 8),
        'title': PlutoCell(value: "Family"),
        'order': PlutoCell(value: 8),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 9),
        'title': PlutoCell(value: "Fantasy"),
        'order': PlutoCell(value: 9),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 10),
        'title': PlutoCell(value: "History"),
        'order': PlutoCell(value: 10),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Title', fields: ['title'], expandedColumn: true),
    PlutoColumnGroup(title: 'Order', fields: ['order'], expandedColumn: true),
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
  Color fontColor = Color.fromARGB(255, 10, 10, 10);
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
            child: addroute == 'main' ? generalWidget() : addNewGenreWidget(),
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
            icon: const Icon(Icons.movie_creation),
            pagename: 'Movies › Genres',
            button: {
              'flag': true,
              'buttoncolor': Colors.white,
              'icon': const Icon(
                Icons.add,
                color: Colors.black,
              ),
              'text': 'Add New Movie',
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

  Widget addNewGenreWidget() {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.movie_creation),
            pagename: 'Movies › Genres › Add New Genre',
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
          titleAndsubtitleInput('Name', 40, 1, ''),
          titleAndsubtitleInput('Order', 40, 1, ''),
          titleAndsubtitleInput('description', 200, 8, ''),
          // titleAndsubtitleTextarea('Description',4,''),
          footer(),
        ],
      ),
    );
  }
  // Widget titleAndsubtitleTextarea(title, line, subtitle) {
  //   return Container(
  //     margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           width: 100,
  //           alignment: Alignment.topLeft,
  //           child: Text(
  //             title,
  //             style: const TextStyle(
  //                 fontSize: 13,
  //                 fontWeight: FontWeight.bold,
  //                 color: Color.fromARGB(255, 15, 15, 15)),
  //           ),
  //         ),
  //         Expanded(
  //           flex: 2,
  //           child: SizedBox(
  //             width: 500,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   width: 500,
  //                   child:TextField(
  //                   maxLines: 4,
  //                   decoration:
  //                     InputDecoration(
  //                       labelText: 'Description',
  //                       fillColor: Colors.white,
  //                       border: new OutlineInputBorder(
  //                         borderRadius: new BorderRadius.circular(10.0),
  //                         borderSide: new BorderSide(
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Text(
  //                   subtitle,
  //                   style: const TextStyle(
  //                     fontSize: 12,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                  color: Color.fromARGB(255, 15, 15, 15)),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
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

  Widget titleAndUpload(title) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: fontColor, fontSize: 13, fontWeight: FontWeight.bold),
          ),
          // const Flexible(
          //   fit: FlexFit.tight,
          //   child: SizedBox(),
          // ),
          Stack(
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
          )
        ],
      ),
    );
  }
}
