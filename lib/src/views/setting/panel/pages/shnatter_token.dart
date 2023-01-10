
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/setting/widget/setting_header.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:badges/badges.dart';

class SettingShnatterTokenScreen extends StatefulWidget {
  SettingShnatterTokenScreen({Key? key}) : super(key: key);
  @override
  State createState() => SettingShnatterTokenScreenState();
}

class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.username, this.joined, this.activated, this.balance, this.actions);

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
                      backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fblank_package.png?alt=media&token=f5cf4503-e36b-416a-8cce-079dfcaeae83'),
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
                value: Badge(
                  toAnimate: false,
                  shape: BadgeShape.square,
                  badgeColor: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                  badgeContent: Text(
                      'No'.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13)),
                )),
              DataGridCell<Widget>(
                columnName: 'balance', 
                value: Badge(
                  toAnimate: false,
                  shape: BadgeShape.square,
                  badgeColor: Colors.teal,
                  borderRadius: BorderRadius.circular(16),
                  badgeContent: Text(
                      0.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13)),
                )),
              DataGridCell<Widget>(
                columnName: 'actions', 
                value: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: (5)),
                      width: 30,
                      child: IconButton(
                        onPressed: (){}, 
                        iconSize: 20,
                        icon: Icon(Icons.replay_5_outlined))),
                    Container(
                      margin: EdgeInsets.only(left: (5)),
                      width: 30,
                      child: IconButton(
                        onPressed: (){}, 
                        iconSize: 20,
                        icon: Icon(Icons.edit))),
                    Container(
                      margin: EdgeInsets.only(left: (5)),
                      width: 30,
                      child: IconButton(
                        onPressed: (){},
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
    return DataGridRowAdapter(cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          child: dataGridCell.columnName == 'activated'
              ? 
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return dataGridCell.value;
                  })
              : dataGridCell.columnName == 'balance'
              ? 
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return dataGridCell.value;
                  })
              : dataGridCell.columnName == 'actions'
              ? 
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return dataGridCell.value;
                  })
              : dataGridCell.columnName == 'name'
              ? 
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return dataGridCell.value;
                  })
              :Text(dataGridCell.value.toString()));
    }).toList());
  }
}

// ignore: must_be_immutable
class SettingShnatterTokenScreenState extends State<SettingShnatterTokenScreen> {
  var setting_security = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SettingHeader(
            icon: const Icon(
              Icons.attach_money,
              color: Color.fromRGBO(76, 175, 80, 1)
            ),
            pagename: 'Shnatter Token',
            button: {'flag': false },
          ),
          Padding(padding: 
            EdgeInsets.only(top: 20)
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.85
                : SizeConfig(context).screenWidth,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: 
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: 330,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(Icons.attach_money, color: Colors.black),
                                Text('Balance', 
                                  style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 330,
                            height: 90,
                            decoration: BoxDecoration (
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  '0.00', 
                                  style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 20.0),),
                    Expanded(child: 
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: 330,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Icon(Icons.attach_money, color: Colors.black),
                                Text('Reserved Balance', 
                                  style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 330,
                            height: 90,
                            decoration: BoxDecoration (
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  '0.00', 
                                  style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // const Padding(padding: EdgeInsets.only(top: 15)),
                Container (
                  margin: EdgeInsets.all(20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(3),
                      backgroundColor: const Color.fromARGB(255, 251, 99, 64),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)
                      ),
                      minimumSize: const Size(720, 40),
                      maximumSize: const Size(720, 40),
                    ),
                    onPressed: () {
                      (()=>{});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Buy Tokens', 
                          style: TextStyle(
                            fontSize: 11, 
                            color: Colors.white, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    )
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blockchain Address', 
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(3),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3.0)
                          ),
                          minimumSize: const Size(330, 50),
                          maximumSize: const Size(330, 50),
                        ),
                        onPressed: () {
                          (()=>{});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'paymail', 
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            Flexible(
                              fit: FlexFit.tight, 
                              child: SizedBox()
                            ),
                            Icon(
                              Icons.file_copy, 
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                generalWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget button({url, text}) {
    return Expanded(
      flex: 1,
      child: Container(
        width: 90,
        height: 90,
        margin: EdgeInsets.all(5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(3),
            backgroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0)
            ),
            minimumSize: const Size(90, 90),
            maximumSize: const Size(90, 90),
          ),
          onPressed: () {
            (()=>{});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                // color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: SvgPicture.network(url),
              ),
              Text(
                text, 
                style: TextStyle(
                  fontSize: 11, 
                  color: Colors.grey, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildProgressIndicator() {
    return Container(
      height: 60.0,
      alignment: Alignment.center,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: BorderDirectional(
          top: BorderSide(
              color: const Color.fromRGBO(0, 0, 0, 0.26)
          ),
        ),
      ),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
        )
      )
    );
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
      Employee(10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
      Employee(10005, 'Martin', 'Developer', '15000', '1005', 'Martin', 'Developer'),
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
          SizeConfig(context).screenWidth > 800 
          ?
          Container(
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.85
                : SizeConfig(context).screenWidth,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Container(
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.85
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

          )
          :
          Container(
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.85
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

