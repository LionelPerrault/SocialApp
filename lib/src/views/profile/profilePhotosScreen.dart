import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/box/mindpost.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import '../../controllers/HomeController.dart';
import '../../routes/route_names.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/ProfileController.dart';
import 'package:shnatter/src/views/profile/model/photos.dart';

import 'model/friends.dart';

class ProfilePhotosScreen extends StatefulWidget {
  Function onClick;
  ProfilePhotosScreen(
      {Key? key,
      required this.onClick,
      // required this.data,
      required this.routerChange})
      : con = ProfileController(),
        super(key: key);
  final ProfileController con;
  // var data;
  Function routerChange;
  @override
  State createState() => ProfilePhotosScreenState();
}

class ProfilePhotosScreenState extends mvc.StateMVC<ProfilePhotosScreen> {
  var userInfo = UserManager.userInfo;
  String tab = 'Photos';
  Photos photoModel = Photos();
  Friends friendModel = Friends();
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as ProfileController;
    friendModel
        .getFriends(ProfileController().viewProfileUserName)
        .then((value) {
      setState(() {});
    });
    photoModel.getPhotos(con.viewProfileUid).then((value) {
      setState(() {});
    });
  }

  bool isMyFriend() {
    //profile selected is my friend?
    String friendUserName;
    for (var item in friendModel.friends) {
      friendUserName = item['requester'].toString();
      if (friendUserName == UserManager.userInfo['userName']) {
        return true;
      }
      if (item['receiver'] == UserManager.userInfo['userName']) {
        return true;
      }
    }
    return false;
  }

  late ProfileController con;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 30, top: 30, bottom: 30, left: 20),
      child: Column(children: [
        mainTabs(),
        tab == 'Photos'
            ? isMyFriend() ||
                    ProfileController().viewProfileUid ==
                        UserManager.userInfo['uid']
                ? PhotosData()
                : Text("You can see the friends data only if you are friends.")
            : isMyFriend() ||
                    ProfileController().viewProfileUid ==
                        UserManager.userInfo['uid']
                ? AlbumsData()
                : Text("You can see the friends data only if you are friends.")
      ]),
    );
  }

  Widget mainTabs() {
    return Container(
      width: SizeConfig(context).screenWidth,
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(3),
      ),
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: const [
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
          //   margin: EdgeInsets.only(top: 15),
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
          //     // MouseRegion(
          //     //   cursor: SystemMouseCursors.click,
          //     //   child: GestureDetector(
          //     //     onTap: () {
          //     //       tab = 'Albums';
          //     //       setState(() {});
          //     //     },
          //     //     child: Container(
          //     //       alignment: Alignment.center,
          //     //       width: 100,
          //     //       height: 40,
          //     //       color: tab == 'Albums'
          //     //           ? Colors.white
          //     //           : Color.fromRGBO(240, 240, 240, 1),
          //     //       child: const Text(
          //     //         'Albums',
          //     //         style: TextStyle(fontSize: 15, color: Colors.black),
          //     //       ),
          //     //     ),
          //     //   ),
          //     // ),
          //   ]),
          // )
        ],
      ),
    );
  }

  Widget PhotosData() {
    return photoModel.photos.isEmpty
        ? Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            height: SizeConfig(context).screenHeight * 0.2,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text('${userInfo['fullName']} doesn`t have photos',
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

  Widget AlbumsData() {
    return photoModel.albums.isEmpty
        ? Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            height: SizeConfig(context).screenHeight * 0.2,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text('${userInfo['fullName']} doesn`t have albums',
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
                    children: photoModel.albums
                        .map((photo) => albumCell(photo))
                        .toList(),
                  ),
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
      child: ElevatedButton(
        onPressed: () {
          widget.routerChange({
            'router': RouteNames.photos,
            'subRouter': value['url'],
          });
        },
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
                  color: Color.fromARGB(255, 150, 99, 99),
                  border: Border.all(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget albumCell(value) {
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
                  image: NetworkImage(value[0]['url']),
                  fit: BoxFit.cover,
                ),
                color: Color.fromARGB(255, 150, 99, 99),
                border: Border.all(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
