import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/views/profile/profileAvatarandTabscreen.dart';
import '../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../controllers/ProfileController.dart';
import 'package:shnatter/src/views/profile/model/photos.dart';

import '../../widget/alertYesNoWidget.dart';
import '../photoView/photoscreen.dart';
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
  final Map _focusedIndices = {};
  Friends friendModel = Friends();
  bool deleteLoading = false;
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
      for (int i = 0; i < photoModel.photos.length; i++) {
        _focusedIndices[i] = false;
      }
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
        isMyFriend() ||
                ProfileController().viewProfileUid ==
                    UserManager.userInfo['uid']
            ? PhotosData()
            : const Text(
                "You can see the friends data only if you are friends.")
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
            padding: const EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SvgPicture.network(Helper.emptySVG, width: 90),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: 140,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Text(
                    'No data to show',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(108, 117, 125, 1)),
                  ))
            ]))
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
                        .map((photo) =>
                            photoCell(photo, photoModel.photos.indexOf(photo)))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
  }

  Widget photoCell(value, index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
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
              border: Border.all(color: Colors.transparent),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoEachScreen(
                    docId: value['url'],
                  ),
                ),
              );
            },
          ),
          ProfileController().viewProfileUid == UserManager.userInfo['uid']
              ? Positioned(
                  top: 5,
                  right: 5,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const SizedBox(),
                          content: AlertYesNoWidget(
                              yesFunc: () {
                                Navigator.of(context).pop(
                                    true); // call Navigator outside of the previous block.
                                // setState(() {
                                //   deleteLoading = true;
                                // });
                                if (UserManager.userInfo['avatar'] ==
                                    value['url']) {
                                  UserManager.userInfo['avatar'] = '';
                                  //  setState(() {});
                                }
                                if (UserManager.userInfo['profile_cover'] ==
                                    value['url']) {
                                  UserManager.userInfo['profile_cover'] = '';
                                  //   setState(() {});
                                }
                                photoModel.photos.removeAt(index);

                                PostController().deletePhoto(value);
                                PostController()
                                    .deletePhotoFromTimeline(value['url']);

//                                 setState(() {
//                                   deleteLoading = false;
// // set flag when both operations have completed successfully
//                                 });
                              },
                              noFunc: () {
                                Navigator.of(context).pop(true);
                              },
                              header: 'Remove Photo',
                              text:
                                  'Do you want to remove photo? it will delete the post of this photo.',
                              progress: deleteLoading),
                        ),
                      );
                    },
                    onHover: (hoverd) {
                      setState(() {
                        _focusedIndices[index] = hoverd;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.clear_outlined,
                            size: 24,
                            color: _focusedIndices[index]
                                ? Colors.white
                                : Colors.white54,
                          ),
                          Icon(
                            Icons.clear_outlined,
                            size: 23,
                            weight: 700,
                            color: _focusedIndices[index]
                                ? Colors.black
                                : Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
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
}
