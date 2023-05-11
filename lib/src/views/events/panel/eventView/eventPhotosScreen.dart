import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';

import '../../../profile/model/photos.dart';

class EventPhotosScreen extends StatefulWidget {
  Function onClick;
  EventPhotosScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => EventPhotosScreenState();
}

class EventPhotosScreenState extends mvc.StateMVC<EventPhotosScreen> {
  var userInfo = UserManager.userInfo;
  String tab = 'Photos';
  Photos photoModel = Photos();
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    photoModel.getPhotosOfEvent(con.viewEventId).then((value) {
      setState(() {});
    });
  }

  late PostController con;

  @override
  Widget build(BuildContext context) {
    return Column(children: [mainTabs(), PhotosData()]);
  }

  Widget mainTabs() {
    return Container(
      width: SizeConfig(context).screenWidth,
      height: 110,
      margin: const EdgeInsets.only(left: 30, right: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(3),
      ),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Container(
              height: 40,
              margin: const EdgeInsets.only(left: 20, top: 20),
              child: const Row(
                children: [
                  Icon(
                    Icons.photo,
                    size: 15,
                  ),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text(
                    'Photos',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              )),
          // Container(
          //   margin: const EdgeInsets.only(top: 22),
          //   child: Row(children: [
          //     MouseRegion(
          //       cursor: SystemMouseCursors.click,
          //       child: GestureDetector(
          //         onTap: () {
          //           tab = 'Photos';
          //           setState(() {});
          //         },
          //         child: Container(
          //           alignment: Alignment.center,
          //           width: 100,
          //           height: 40,
          //           color: tab == 'Photos'
          //               ? Colors.white
          //               : Color.fromRGBO(240, 240, 240, 1),
          //           child: const Text(
          //             'Photos',
          //             style: TextStyle(fontSize: 15, color: Colors.black),
          //           ),
          //         ),
          //       ),
          //     ),
          //     MouseRegion(
          //       cursor: SystemMouseCursors.click,
          //       child: GestureDetector(
          //         onTap: () {
          //           tab = 'Albums';
          //           setState(() {});
          //         },
          //         child: Container(
          //           alignment: Alignment.center,
          //           width: 100,
          //           height: 40,
          //           color: tab == 'Albums'
          //               ? Colors.white
          //               : Color.fromRGBO(240, 240, 240, 1),
          //           child: const Text(
          //             'Albums',
          //             style: TextStyle(fontSize: 15, color: Colors.black),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ]),
          // )
        ],
      ),
    );
  }

  Widget PhotosData() {
    return photoModel.photos.isEmpty
        ? Container(
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: Text('${con.event['eventName']} doesn`t have photos',
                style:
                    const TextStyle(color: Color.fromRGBO(108, 117, 125, 1))),
          )
        : Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: GridView.count(
                    crossAxisCount: SizeConfig(context).screenWidth > 800
                        ? 6
                        : SizeConfig(context).screenWidth > 600
                            ? 4
                            : SizeConfig(context).screenWidth > 210
                                ? 3
                                : 2,
                    childAspectRatio: 3 / 3,
                    padding: const EdgeInsets.only(top: 30),
                    mainAxisSpacing: 4.0,
                    shrinkWrap: true,
                    crossAxisSpacing: 4.0,
                    children: photoModel.photos
                        .map((photo) => photoCell(photo))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
  }

  Widget albumCell(value) {
    return Container(
      alignment: Alignment.center,
      width: 200,
      height: 110,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            alignment: Alignment.topCenter,
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(value[0]['url']),
                  fit: BoxFit.cover,
                ),
                color: const Color.fromARGB(255, 150, 99, 99),
                border: Border.all(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget photoCell(value) {
    print("value---------$value");
    return Container(
      alignment: Alignment.center,
      width: 200,
      height: 110,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            alignment: Alignment.topCenter,
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(value['url']),
                  fit: BoxFit.cover,
                ),
                color: const Color.fromARGB(255, 150, 99, 99),
                border: Border.all(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
