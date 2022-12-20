import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminCurrencies extends StatefulWidget {
  AdminCurrencies({super.key});

  @override
  State createState() => AdminCurrenciesState();
}

class AdminCurrenciesState extends mvc.StateMVC<AdminCurrencies> {
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
      title: 'Code',
      field: 'code',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Symbol',
      field: 'symbol',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Default',
      field: 'default',
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
        'name': PlutoCell(value: 'user1'),
        'code': PlutoCell(value: 'user1'),
        'symbol': PlutoCell(value: 'user1'),
        'default': PlutoCell(value: 'user1'),
        'actions': PlutoCell(value: 'user1'),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Name', fields: ['name'], expandedColumn: true),
    PlutoColumnGroup(title: 'Code', fields: ['code'], expandedColumn: true),
    PlutoColumnGroup(title: 'Symbol', fields: ['symbol'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Default', fields: ['default'], expandedColumn: true),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.settings),
            pagename: 'Settings',
            button: const {'flag': false},
          ),
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
