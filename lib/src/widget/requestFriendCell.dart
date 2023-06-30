// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';

class RequestFriendCell extends StatefulWidget {
  RequestFriendCell(
      {super.key,
      required this.cellData,
      this.hideMenu,
      required this.onClick,
      required this.routerChange})
      : con = PeopleController();
  late PeopleController con;
  var hideMenu;
  Function onClick;
  Function routerChange;

  dynamic cellData;
  @override
  State createState() => RequestFriendCellState();
}

class RequestFriendCellState extends mvc.StateMVC<RequestFriendCell> {
  late PeopleController con;
  Color color = const Color.fromRGBO(230, 236, 245, 1);

  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PeopleController;
    print(widget.cellData);
  }

  @override
  Widget build(BuildContext context) {
    var e = widget.cellData;
    var friendUseruid = e['uid'];
    var friendFullName = e['fullName'];
    var friendAvatar = e['avatar'];
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Column(
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
                InkWell(
                  onTap: () async {
                    await ProfileController().updateProfile(e['userName']);
                    print(e);
                    if (widget.hideMenu != null) {
                      widget.hideMenu();
                    }
                    widget.routerChange({
                      'router': RouteNames.profile,
                      'subRouter': e['userName'],
                    });
                    print('Tapped on friend avatar and name');
                  },
                  child: Row(
                    children: [
                      friendAvatar == ''
                          ? CircleAvatar(
                              radius: 20,
                              child: SvgPicture.network(Helper.avatar),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(friendAvatar),
                            ),
                      Container(
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          friendFullName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Flexible(fit: FlexFit.tight, child: SizedBox()),
                Container(
                  padding: const EdgeInsets.only(top: 6),
                  child: (e['state'] == null || e['state'] == 0)
                      ? Row(children: [
                          ElevatedButton(
                            onPressed: () async {
                              e['state'] = -1;
                              setState(() {});
                              await con.confirmFriend(e['fieldUid']);

                              e['state'] = 1;
                              widget.onClick();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0)),
                                minimumSize: (e as Map).containsKey('state') &&
                                        e['state'] == -1
                                    ? const Size(80, 35)
                                    : const Size(80, 35),
                                maximumSize:
                                    (e).containsKey('state') && e['state'] == -1
                                        ? const Size(80, 35)
                                        : const Size(80, 35)),
                            child: e.containsKey('state') && e['state'] == -1
                                ? const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  )
                                : const FittedBox(
                                    // Replace the Text widget with FittedBox
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 5)),
                          ElevatedButton(
                            onHover: (value) {},
                            onPressed: () async {
                              e['state'] = -2;
                              setState(() {});
                              await con.rejectFriend(e['fieldUid']);
                              e['state'] = 2;
                              widget.onClick();
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(245, 54, 92, 1),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0)),
                                minimumSize:
                                    (e).containsKey('state') && e['state'] == -2
                                        ? const Size(80, 35)
                                        : const Size(80, 35),
                                maximumSize:
                                    (e).containsKey('state') && e['state'] == -2
                                        ? const Size(80, 35)
                                        : const Size(80, 35)),
                            child: (e).containsKey('state') && e['state'] == -2
                                ? const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const FittedBox(
                                    // Replace the Text widget with FittedBox
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Decline',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                          )
                        ])
                      : ElevatedButton(
                          onPressed: () async {
                            // e['state'] = -3;
                            // setState(() {});
                            // await PeopleController()
                            //     .cancelFriend({"userName": friendUseruid});
                            // e['state'] = 2;
                            // setState(() {});
                            if (e['state'] == 1) {
                              e['state'] = -3;
                              setState(() {});
                              await PeopleController()
                                  .cancelFriend({"uid": friendUseruid});
                              e['state'] = 3;
                              //widget.onClick();
                              setState(() {});
                            } else if (e['state'] == 2) {
                              e['state'] = -3;
                              setState(() {});
                              var requester = e['uid'];
                              e['id'] =
                                  await con.requestFriendAsData(requester);
                              e['state'] = 0;
                              widget.onClick();
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  e['state'] == 1 ? Colors.red : Colors.black,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0)),
                              minimumSize: (e as Map).containsKey('state') &&
                                      e['state'] == -3
                                  ? const Size(60, 35)
                                  : const Size(90, 35),
                              maximumSize:
                                  (e).containsKey('state') && e['state'] == -3
                                      ? const Size(60, 35)
                                      : const Size(90, 35)),
                          child: (e).containsKey('state') &&
                                  (e['state'] == -3 ||
                                      e['state'] == -1 ||
                                      e['state'] == -2)
                              ? const SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 13,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 3)),
                                    ((e).containsKey('state') &&
                                            e['state'] == 1)
                                        ? const Text('Delete',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w900))
                                        : const Text('Rejected',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w900))
                                  ],
                                ),
                        ),
                )
              ]),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            height: 1,
            color: color,
          ),
        ],
      ),
    );
  }
}
