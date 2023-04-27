import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/postCell.dart';

class PostEachScreen extends StatefulWidget {
  PostEachScreen({Key? key, required this.docId, required this.routerChange})
      : con = PostController(),
        super(key: key);
  final PostController con;
  String docId;
  Function routerChange;

  @override
  State createState() => PostEachScreenState();
}

class PostEachScreenState extends mvc.StateMVC<PostEachScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  late PostController con;
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    getSelectedPost(widget.docId);
  }

  void getSelectedPost(String docId) {
    con.getSelectedPost(docId).then((value) => {
          loading = false,
          setState(() {}),
          print('You get selected post info!'),
        });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig(context).screenWidth < 600
          ? SizeConfig(context).screenWidth
          : 600,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                Container(
                  width: SizeConfig(context).screenWidth >
                          SizeConfig.mediumScreenSize
                      ? 700
                      : SizeConfig(context).screenWidth > 600
                          ? 600
                          : SizeConfig(context).screenWidth,
                  padding: EdgeInsets.only(top: 100),
                  child: loading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Container(
                                width: 50,
                                height: 50,
                                margin: EdgeInsets.only(
                                    top: SizeConfig(context).screenHeight *
                                        2 /
                                        5),
                                child: const CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              )
                            ])
                      : PostCell(
                          postInfo: con.post,
                          routerChange: widget.routerChange,
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
