import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/postCell.dart';

import '../../routes/route_names.dart';

class PhotoEachScreen extends StatefulWidget {
  PhotoEachScreen({Key? key, required this.docId})
      : con = PostController(),
        super(key: key);
  final PostController con;
  String docId;

  @override
  State createState() => PhotoEachScreenState();
}

class PhotoEachScreenState extends mvc.StateMVC<PhotoEachScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  late PostController con;
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    print(widget.docId);
    //  getSelectedPhoto(widget.docId);
  }

  void getSelectedPhoto(String docId) {
    con.getSelectedPost(docId).then((value) => {
          loading = false,
          setState(() {}),
          print('You get selected post info!'),
        });
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: SizeConfig(context).screenWidth < SizeConfig.mediumScreenSize
    //       ? SizeConfig(context).screenWidth
    //       : SizeConfig(context).screenWidth - 200,
    //   height: SizeConfig(context).screenHeight - 120,
    //   decoration: BoxDecoration(
    //     color: Colors.black,
    //     image: DecorationImage(
    //       image: NetworkImage(widget.docId),
    //       fit: BoxFit.contain,
    //     ),
    //   ),
    // );

    return Stack(
      children: [
        Container(
          color: Colors.black,
          width: SizeConfig(context).screenWidth,
          height: SizeConfig(context).screenHeight,
          alignment: Alignment.center,
          child: Container(
            color: Colors.black,
            child: Center(
              child: FittedBox(
                fit: BoxFit.none,
                child: LimitedBox(
                  maxWidth: SizeConfig(context).screenWidth,
                  maxHeight: SizeConfig(context).screenHeight,
                  child: Image.network(widget.docId),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
