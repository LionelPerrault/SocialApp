// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shnatter/src/views/footerbar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
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
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;

  @override
  void initState() {
    super.initState();
    employees = getEmployeeData();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
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

  Widget _buildProgressIndicator() {
    return Container(
        height: 60.0,
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          border: BorderDirectional(
            top: BorderSide(color: const Color.fromRGBO(0, 0, 0, 0.26)),
          ),
        ),
        child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
            )));
  }

  Widget _buildLoadMoreView(BuildContext context, LoadMoreRows loadMoreRows) {
    Future<String> loadRows() async {
      // Call the loadMoreRows function to call the
      // DataGridSource.handleLoadMoreRows method. So, additional
      // rows can be added from handleLoadMoreRows method.
      await loadMoreRows();
      return Future<String>.value('Completed');
    }

    return FutureBuilder<String>(
      initialData: 'Loading',
      future: loadRows(),
      builder: (BuildContext context, AsyncSnapshot<String> snapShot) {
        print(snapShot.data);
        return snapShot.data == 'Loading'
            ? _buildProgressIndicator()
            : SizedBox.fromSize(size: Size.zero);
      },
    );
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(
          10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(
          10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(
          10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(
          10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(
          10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(
          10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(
          10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(
          10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
    ];
  }

  List<GridColumn> _getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'ID',
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: const Text(
                'ID',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'Name',
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: const Text(
                'Name',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'Username',
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: const Text(
                'Username',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'Joined',
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: const Text(
                'Joined',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'Activated',
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: const Text(
                'Activated',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'Balance',
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: const Text(
                'Balance',
                overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'Actions',
          columnWidthMode: ColumnWidthMode.lastColumnFill,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              child: const Text(
                'Actions',
                overflow: TextOverflow.ellipsis,
              )))
    ];
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
          SizeConfig(context).screenWidth > 800
              ? Container(
                  width: SizeConfig(context).screenWidth > 800
                      ? SizeConfig(context).screenWidth * 0.75
                      : SizeConfig(context).screenWidth,
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 15.0),
                        ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(left: 10)),
                                      Column(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(top: 10.0),
                                          ),
                                          Text('76',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w900)),
                                          Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                          ),
                                          Text('Users',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16)),
                                        ],
                                      ),
                                      const Flexible(
                                          fit: FlexFit.tight,
                                          child: SizedBox()),
                                      SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: FittedBox(
                                            child: Icon(
                                              Icons.groups_rounded,
                                              color: Colors.deepPurple[100],
                                            ),
                                          ))
                                    ]),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                            ),
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
                                child: Row(children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  Column(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                      ),
                                      Text('0',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w900)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                      ),
                                      Text('Banned',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  ),
                                  const Flexible(
                                      fit: FlexFit.tight, child: SizedBox()),
                                  SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: FittedBox(
                                        child: Icon(
                                          Icons.remove_circle_rounded,
                                          color: Colors.deepPurple[100],
                                        ),
                                      ))
                                ]),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                            ),
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
                                child: Row(children: [
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  Column(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                      ),
                                      Text('3',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w900)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                      ),
                                      Text('Not Activated',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  ),
                                  const Flexible(
                                      fit: FlexFit.tight, child: SizedBox()),
                                  SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: FittedBox(
                                        child: Icon(
                                          Icons.mail,
                                          color: Colors.deepPurple[100],
                                        ),
                                      ))
                                ]),
                              ),
                            ),
                          ],
                        )
                      ]),
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 0, left: 15, right: 15),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                          ),
                          Container(
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
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  Column(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                      ),
                                      Text('76',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w900)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                      ),
                                      Text('Users',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  ),
                                  const Flexible(
                                      fit: FlexFit.tight, child: SizedBox()),
                                  SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: FittedBox(
                                        child: Icon(
                                          Icons.groups_rounded,
                                          color: Colors.deepPurple[100],
                                        ),
                                      ))
                                ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0, left: 15, right: 15),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                          ),
                          Container(
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
                            child: Row(children: [
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Column(
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  Text('0',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900)),
                                  Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                  ),
                                  Text('Banned',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                ],
                              ),
                              const Flexible(
                                  fit: FlexFit.tight, child: SizedBox()),
                              SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: FittedBox(
                                    child: Icon(
                                      Icons.remove_circle_rounded,
                                      color: Colors.deepPurple[100],
                                    ),
                                  ))
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0, left: 15, right: 15),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                          ),
                          Container(
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
                              child: Row(children: [
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Column(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                    ),
                                    Text('3',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w900)),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                    ),
                                    Text('Not Activated',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                  ],
                                ),
                                const Flexible(
                                    fit: FlexFit.tight, child: SizedBox()),
                                SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: FittedBox(
                                      child: Icon(
                                        Icons.mail,
                                        color: Colors.deepPurple[100],
                                      ),
                                    ))
                              ])),
                        ],
                      ),
                    ),
                  ],
                ),
          Container(
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.75
                : SizeConfig(context).screenWidth,
            // height: SizeConfig(context).screenHeight - SizeConfig.navbarHeight,
            padding: const EdgeInsets.all(15),
            child: SfDataGrid(
              allowSorting: true,
              allowFiltering: true,
              loadMoreViewBuilder: _buildLoadMoreView,
              source: employeeDataSource,
              columns: _getColumns(),
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
            ),
          ),
        ],
      ),
    );
  }
}

class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.username, this.joined, this.activated,
      this.balance, this.actions);

  /// Id of an employee.
  final int id;

  /// name of an employee.
  final String name;

  /// username of an employee.
  final String username;

  /// joined of an employee.
  final String joined;

  /// activated of an employee.
  final String activated;

  /// balance of an employee.
  final String balance;

  /// actions of an employee.
  final String actions;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<Widget>(
                  columnName: 'name',
                  value: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 16,
                        backgroundImage: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83'),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(e.name),
                      )
                    ],
                  )),
              DataGridCell(columnName: 'username', value: e.username),
              DataGridCell<String>(columnName: 'joined', value: e.joined),
              DataGridCell<Widget>(
                  columnName: 'activated',
                  value: badges.Badge(
                    toAnimate: false,
                    shape: badges.BadgeShape.square,
                    badgeColor: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                    badgeContent: Text('No'.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13)),
                  )),
              DataGridCell<Widget>(
                  columnName: 'balance',
                  value: badges.Badge(
                    toAnimate: false,
                    shape: badges.BadgeShape.square,
                    badgeColor: Colors.teal,
                    borderRadius: BorderRadius.circular(16),
                    badgeContent: Text(0.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13)),
                  )),
              DataGridCell<Widget>(
                  columnName: 'actions',
                  value: Row(children: [
                    Container(
                        margin: EdgeInsets.only(left: (5)),
                        width: 30,
                        child: IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            icon: Icon(Icons.replay_5_outlined))),
                    Container(
                        margin: EdgeInsets.only(left: (5)),
                        width: 30,
                        child: IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            icon: Icon(Icons.edit))),
                    Container(
                        margin: EdgeInsets.only(left: (5)),
                        width: 30,
                        child: IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            color: Colors.red,
                            icon: Icon(Icons.delete)))
                  ])),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          child: dataGridCell.columnName == 'activated'
              ? LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                  return dataGridCell.value;
                })
              : dataGridCell.columnName == 'balance'
                  ? LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                      return dataGridCell.value;
                    })
                  : dataGridCell.columnName == 'actions'
                      ? LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                          return dataGridCell.value;
                        })
                      : dataGridCell.columnName == 'name'
                          ? LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                              return dataGridCell.value;
                            })
                          : Text(dataGridCell.value.toString()));
    }).toList());
  }
}
