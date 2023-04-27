import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminListMovies extends StatefulWidget {
  AdminListMovies({super.key});

  @override
  State createState() => AdminListMoviesState();
}

class AdminListMoviesState extends mvc.StateMVC<AdminListMovies> {
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
      title: 'Source',
      field: 'source',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Release',
      field: 'release',
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
        'title': PlutoCell(value: "The Tiger"),
        'source': PlutoCell(value: 'The Movie Company'),
        'release': PlutoCell(value: '+ 100'),
        'actions': PlutoCell(value: 'Action'),
      },
    ),
  ];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Title', fields: ['title'], expandedColumn: true),
    PlutoColumnGroup(title: 'Source', fields: ['source'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Release', fields: ['release'], expandedColumn: true),
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
  Color fontColor = const Color.fromARGB(255, 10, 10, 10);
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
            child: addroute == 'main' ? generalWidget() : addNewMovieWidget(),
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
          icon: const Icon(Icons.movie_creation),
          pagename: 'Movies',
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
            'size': const Size(180, 50),
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
            onChanged: (PlutoGridOnChangedEvent event) {},
          ),
        ),
      ],
    );
  }

  Widget addNewMovieWidget() {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.movie_creation),
            pagename: 'Movies › Add New Movie',
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
          titleAndsubtitleInput('Movie Source', 40, 1,
              'From YouTube, Vimeo or site.com/movie.mp4'),
          titleAndUpload('Or Upload Movie'),
          titleAndsubtitleInput('Movie Title', 40, 1, ''),
          titleAndsubtitleInput('Description', 80, 4, ''),
          titleAndsubtitleInput('IMDB', 40, 1,
              'IMDB Link, Example: https://www.imdb.com/title/tt0111161'),
          titleAndsubtitleInput('Movie Star', 80, 4,
              'Separated by a comma (,) Example: Tom Hanks, Julia Roberts, Jim Carrey'),
          titleAndsubtitleInput(
              'Release Year', 40, 1, 'Movie release year, Example: 1995'),
          titleAndsubtitleInput(
              'Duration', 40, 1, 'Movie duration in minutes, Example: 120'),
          titleAndUpload('Poster'),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          minimumSize: const Size(150, 50),
          maximumSize: const Size(150, 50),
        ),
        onPressed: () {
          () => {};
        },
        child: const Text(
          'Save Changes',
          style: TextStyle(
              color: Color.fromARGB(255, 33, 37, 41),
              fontSize: 11.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
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
          const Flexible(
            fit: FlexFit.tight,
            child: SizedBox(),
          ),
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
