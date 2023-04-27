import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class AdminUsersList extends StatefulWidget {
  AdminUsersList({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;

  @override
  State createState() => AdminUsersListState();
}

class AdminUsersListState extends mvc.StateMVC<AdminUsersList> {
  late AdminController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as AdminController;
    con.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          width: SizeConfig(context).screenWidth > 800
              ? SizeConfig(context).screenWidth * 0.75
              : SizeConfig(context).screenWidth,
          child: generalWidget(),
        ),
      ],
    );
  }

  Widget generalWidget() {
    return Container(
      alignment: Alignment.center,
      width: SizeConfig(context).screenWidth > 800
          ? SizeConfig(context).screenWidth * 0.75
          : SizeConfig(context).screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.groups),
            pagename: 'List Users',
            button: const {
              'flag': false,
            },
          ),
          Container(
            alignment: Alignment.center,
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.75
                : SizeConfig(context).screenWidth,
            height: 400,
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: con.usersList.length,
              itemBuilder: (BuildContext context, int index) {
                return listCell(con.usersList[index]);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ],
      ),
    );
  }

  listCell(itemData) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          itemData['avatar'] == ''
              ? CircleAvatar(
                  radius: 17, child: SvgPicture.network(Helper.avatar))
              : CircleAvatar(
                  radius: 17,
                  backgroundImage: NetworkImage(itemData['avatar'])),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '${itemData['firstName']} ${itemData['lastName']}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                itemData['userName'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                itemData['email'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '${itemData['paymail'].replaceAll('@shnatter.app', '')}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
