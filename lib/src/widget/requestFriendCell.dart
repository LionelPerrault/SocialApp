// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';

class RequestFriendCell extends StatefulWidget {
  RequestFriendCell(
      {super.key,
      required this.cellData,
      required this.onClick,
      required this.routerChange})
      : con = PeopleController();
  late PeopleController con;
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
  }

  @override
  Widget build(BuildContext context) {
    var e = widget.cellData;
    return Container(
        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(left: 10)),
                  e.value[e.value['requester']]['avatar'] == ''
                      ? CircleAvatar(
                          radius: 20, child: SvgPicture.network(Helper.avatar))
                      : CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              e.value[e.value['requester']]['avatar'])),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: InkWell(
                        onTap: () {
                          widget.routerChange({
                            'router': RouteNames.profile,
                            'subRouter': e.value['requester']
                          });
                        },
                        child: Text(
                          e.value[e.value['requester']]['name'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 11),
                        )),
                  ),
                  const Flexible(fit: FlexFit.tight, child: SizedBox()),
                  Container(
                    padding: const EdgeInsets.only(top: 6),
                    child: e.value['state'] == 0
                        ? Row(children: [
                            ElevatedButton(
                              onPressed: () async {
                                e.value['state'] = -1;
                                setState(() {});
                                await con.confirmFriend(e.value['id']);
                                e.value['state'] = 1;
                                widget.onClick();
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0)),
                                  minimumSize:
                                      (e.value as Map).containsKey('state') &&
                                              e.value['state'] == -1
                                          ? const Size(60, 35)
                                          : const Size(80, 35),
                                  maximumSize:
                                      (e.value as Map).containsKey('state') &&
                                              e.value['state'] == -1
                                          ? const Size(60, 35)
                                          : const Size(80, 35)),
                              child: (e.value as Map).containsKey('state') &&
                                      e.value['state'] == -1
                                  ? const SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text('Confirm',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900)),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            ElevatedButton(
                              onHover: (value) {},
                              onPressed: () async {
                                e.value['state'] = -2;
                                setState(() {});
                                await con.rejectFriend(e.value['id']);
                                e.value['state'] = 2;
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
                                      (e.value as Map).containsKey('state') &&
                                              e.value['state'] == -2
                                          ? const Size(60, 35)
                                          : const Size(80, 35),
                                  maximumSize:
                                      (e.value as Map).containsKey('state') &&
                                              e.value['state'] == -2
                                          ? const Size(60, 35)
                                          : const Size(80, 35)),
                              child: (e.value as Map).containsKey('state') &&
                                      e.value['state'] == -2
                                  ? const SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Decline',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w900)),
                            )
                          ])
                        : ElevatedButton(
                            onPressed: () async {
                              if (e.value['state'] == 1) {
                                e.value['state'] = -3;
                                setState(() {});
                                await con.rejectFriend(e.value['id']);
                                e.value['state'] = 2;
                                widget.onClick();
                                setState(() {});
                              } else {
                                if (e.value['state'] == 2) {
                                  e.value['state'] = -3;
                                  setState(() {});
                                  var requester = e.value['requester'];
                                  var name = e.value[requester]['name'];
                                  var avatar = e.value[requester]['avatar'];
                                  e.value['id'] = await con.requestFriendAsData(
                                      requester, name, avatar);
                                  e.value['state'] = 0;
                                  widget.onClick();
                                  setState(() {});
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: e.value['state'] == 1
                                    ? Colors.green
                                    : Colors.black,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2.0)),
                                minimumSize:
                                    (e.value as Map).containsKey('state') &&
                                            e.value['state'] == -3
                                        ? const Size(50, 35)
                                        : const Size(80, 35),
                                maximumSize:
                                    (e.value as Map).containsKey('state') &&
                                            e.value['state'] == -3
                                        ? const Size(50, 35)
                                        : const Size(80, 35)),
                            child: (e.value as Map).containsKey('state') &&
                                    (e.value['state'] == -3 ||
                                        e.value['state'] == -1 ||
                                        e.value['state'] == -2)
                                ? SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 13,
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(left: 3)),
                                      ((e.value as Map).containsKey('state') &&
                                              e.value['state'] == 1)
                                          ? const Text('Friend',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w900))
                                          : const Text('Add',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w900))
                                    ],
                                  ),
                          ),
                  )
                ]),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              height: 1,
              color: color,
            ),
          ],
        ));
  }
}
