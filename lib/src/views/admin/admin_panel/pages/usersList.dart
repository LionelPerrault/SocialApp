import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminUserList extends StatefulWidget {
  AdminUserList({super.key});

  @override
  State createState() => AdminUserListState();
}

class AdminUserListState extends mvc.StateMVC<AdminUserList> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Username',
      field: 'username',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Joined',
      field: 'joined',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Activated',
      field: 'activated',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Balance',
      field: 'balance',
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
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'name': PlutoCell(value: 'Shnatter Admin'),
        'username': PlutoCell(value: 'shnatter'),
        'joined': PlutoCell(value: 'joined'),
        'activated': PlutoCell(value: 'yes'),
        'balance': PlutoCell(value: 0),
        'actions': PlutoCell(value: 'asdfasd'),
      },
    ),
    
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Name', fields: ['name'], expandedColumn: true),
    PlutoColumnGroup(title: 'Username', fields: ['username'], expandedColumn: true),
    PlutoColumnGroup(title: 'Joined', fields: ['joined'], expandedColumn: true),
    PlutoColumnGroup(title: 'Activated', fields: ['activated'], expandedColumn: true),
    PlutoColumnGroup(title: 'Balance', fields: ['balance'], expandedColumn: true),
    PlutoColumnGroup(title: 'Actions', fields: ['actions'], expandedColumn: true),
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
            child: generalWidget(),
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
            icon: const Icon(Icons.person),
            pagename: 'Users',
            button: const {
              'flag': false,
            },
          ),
          
          Container(
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.75
                : SizeConfig(context).screenWidth,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 15.0),),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 280,
                        height: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromARGB(255, 94, 114, 228),
                              Color.fromARGB(255, 130, 94, 228),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 10.0),),
                              Text('76', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 8.0),),
                              Text('Users', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: FittedBox(child: Icon(
                                Icons.groups_rounded,
                                color: Colors.deepPurple[100],
                              ),)
                            )
                          ]
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 20.0),),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 280,
                        height: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromARGB(255, 245, 54, 92),
                              Color.fromARGB(255, 245, 96, 54),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 10.0),),
                              Text('0', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 8.0),),
                              Text('Banned', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: FittedBox(child: Icon(
                                    Icons.remove_circle_rounded,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 0.0),),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 280,
                        height: 85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromARGB(255, 251, 99, 64),
                              Color.fromARGB(255, 251, 177, 64),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 10.0),),
                              Text('3', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 8.0),),
                              Text('Not Activated', style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: FittedBox(child: Icon(
                                    Icons.mail,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ),
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
}
