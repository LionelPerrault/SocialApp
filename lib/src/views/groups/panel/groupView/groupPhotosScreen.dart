import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shnatter/src/helpers/helper.dart';
import '../../../profile/model/photos.dart';

// ignore: must_be_immutable
class GroupPhotosScreen extends StatefulWidget {
  Function onClick;
  GroupPhotosScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => GroupPhotosScreenState();
}

class GroupPhotosScreenState extends mvc.StateMVC<GroupPhotosScreen> {
  var userInfo = UserManager.userInfo;
  String tab = 'Photos';
  Photos photoModel = Photos();
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    photoModel.getPhotosOfGroup(con.viewGroupId).then((value) {
      setState(() {});
    });
  }

  late PostController con;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      photoModel.photos.isEmpty ? const SizedBox() : mainTabs(),
      PhotosData()
    ]);
  }

  Widget mainTabs() {
    return Container(
      width: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
          ? SizeConfig(context).screenWidth - SizeConfig.leftBarWidth - 60
          : SizeConfig(context).screenWidth - 60,
      height: 70,
      margin: const EdgeInsets.only(left: 30, right: 30),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(240, 240, 240, 1),
        borderRadius: BorderRadius.circular(3),
      ),
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
        ],
      ),
    );
  }

  Widget PhotosData() {
    var screenWidth = SizeConfig(context).screenWidth - SizeConfig.leftBarWidth;
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 40),
      child: photoModel.photos.isEmpty
          ? Container(
              padding: const EdgeInsets.only(top: 40),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20),
                  width: SizeConfig(context).screenWidth >
                          SizeConfig.mediumScreenSize
                      ? SizeConfig(context).screenWidth -
                          SizeConfig.leftBarWidth -
                          100
                      : SizeConfig(context).screenWidth - 60,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: screenWidth > 900
                        ? 3
                        : screenWidth > 500
                            ? 2
                            : 1,
                    childAspectRatio: 1,
                    padding: const EdgeInsets.all(4.0),
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

  Widget photoCell(value) {
    print("value---------$value");
    return Container(
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
    );
  }

  Widget albumCell(value) {
    return Container(
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
    );
  }
}
