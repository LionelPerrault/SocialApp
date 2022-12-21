import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminShnatterToken extends StatefulWidget {
  AdminShnatterToken({super.key});

  @override
  State createState() => AdminShnatterTokenState();
}

class AdminShnatterTokenState extends mvc.StateMVC<AdminShnatterToken> {
  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Amount',
      field: 'amount',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Sender',
      field: 'sender',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Recipient',
      field: 'recipient',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Note',
      field: 'note',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Created at',
      field: 'createdat',
      type: PlutoColumnType.text(),
    ),
  ];

  final List<PlutoRow> rows = [
    PlutoRow(
      cells: {
        'id': PlutoCell(value: 1),
        'amount': PlutoCell(value: 5.00),
        'sender': PlutoCell(value: 'BS192901'),
        'recipient': PlutoCell(value: 'TREASURE'),
        'note': PlutoCell(value: 'no have note'),
        'createdat': PlutoCell(value: 'an hour ago'),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Amount', fields: ['amount'], expandedColumn: true),
    PlutoColumnGroup(title: 'Sender', fields: ['sender'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Recipient', fields: ['recipient'], expandedColumn: true),
    PlutoColumnGroup(title: 'Note', fields: ['note'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Created at', fields: ['createdat'], expandedColumn: true),
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
            icon: const Icon(Icons.display_settings),
            pagename: 'Themes',
            button: const {
              'flag': false,
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
}
