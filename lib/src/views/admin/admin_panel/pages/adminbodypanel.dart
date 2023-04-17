import 'package:flutter/material.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

class AdminMainPanel extends StatefulWidget {
  AdminMainPanel({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;

  @override
  State createState() => AdminMainPanelState();
}

class AdminMainPanelState extends mvc.StateMVC<AdminMainPanel> {
  late AdminController con;
  @override
  void initState() {
    add(widget.con);
    con = controller as AdminController;
    con.getBodyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
        ? Container(
            margin: EdgeInsets.only(top: 0, left: 60, right: 60),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromARGB(255, 94, 114, 228),
                              Color.fromARGB(255, 130, 94, 228),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 7.0),
                                  ),
                                  Text('${con.usersNum}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900)),
                                  const Text('Users',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11)),
                                  const Text('Manage Users',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                                ],
                              ),
                              const Flexible(
                                  fit: FlexFit.tight, child: SizedBox()),
                              SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: FittedBox(
                                    child: Icon(
                                      Icons.groups_rounded,
                                      color: Colors.deepPurple[100],
                                    ),
                                  ))
                            ]),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromARGB(255, 17, 205, 239),
                              Color.fromARGB(255, 17, 113, 239),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Row(children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 7.0),
                              ),
                              Text('${con.onlineUsers}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900)),
                              const Text('Online',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11)),
                              const Text('Manage Online',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ],
                          ),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                              width: 80,
                              height: 80,
                              child: FittedBox(
                                child: Icon(
                                  Icons.timer,
                                  color: Colors.deepPurple[100],
                                ),
                              ))
                        ]),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 288,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromARGB(255, 45, 206, 137),
                              Color.fromARGB(255, 45, 206, 204),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Row(children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 7.0),
                              ),
                              Text('${con.postsNum}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900)),
                              const Text('Posts',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11)),
                              const Text('Manage Posts',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ],
                          ),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                              width: 100,
                              height: 100,
                              child: FittedBox(
                                child: Icon(
                                  Icons.newspaper,
                                  color: Colors.deepPurple[100],
                                ),
                              ))
                        ]),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 190,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromARGB(255, 94, 114, 228),
                              Color.fromARGB(255, 130, 94, 228),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Row(children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 7.0),
                              ),
                              Text('${con.groupsNum}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900)),
                              const Text('Groups',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11)),
                              const Text('Manage Groups',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ],
                          ),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                              width: 80,
                              height: 100,
                              child: FittedBox(
                                child: Icon(
                                  Icons.groups_rounded,
                                  color: Colors.deepPurple[100],
                                ),
                              ))
                        ]),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 190,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromARGB(255, 94, 114, 228),
                              Color.fromARGB(255, 130, 94, 228),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Row(children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 7.0),
                              ),
                              Text('${con.eventsNum}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900)),
                              const Text('Events',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11)),
                              const Text('Manage Events',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ],
                          ),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                              width: 80,
                              height: 80,
                              child: FittedBox(
                                child: Icon(
                                  Icons.event_outlined,
                                  color: Colors.deepPurple[100],
                                ),
                              ))
                        ]),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: 580,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              Color.fromARGB(255, 43, 255, 198),
                              Color.fromARGB(255, 43, 224, 255),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Row(children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Row(
                            children: [
                              Text('${con.treasure}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900)),
                              const Padding(
                                padding: EdgeInsets.only(left: 5.0),
                              ),
                              const Text('Treasure balance',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11)),
                            ],
                          ),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              minimumSize: const Size(50, 50),
                              maximumSize: const Size(50, 50),
                            ),
                            child: const Icon(
                              Icons.sync,
                              color: Colors.black,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(right: 10))
                        ]),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
              ],
            ),
          )
        : Container(
            margin: const EdgeInsets.only(top: 0, left: 30, right: 30),
            width: SizeConfig(context).screenWidth - 60,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Container(
                  height: 100,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: <Color>[
                        Color.fromARGB(255, 94, 114, 228),
                        Color.fromARGB(255, 130, 94, 228),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 7.0),
                            ),
                            Text('${con.usersNum}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w900)),
                            const Text('Users',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11)),
                            const Text('Manage Users',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10)),
                          ],
                        ),
                        const Flexible(fit: FlexFit.tight, child: SizedBox()),
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: FittedBox(
                              child: Icon(
                                Icons.groups_rounded,
                                color: Colors.deepPurple[100],
                              ),
                            ))
                      ]),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: <Color>[
                        Color.fromARGB(255, 17, 205, 239),
                        Color.fromARGB(255, 17, 113, 239),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Row(children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 7.0),
                        ),
                        Text('${con.onlineUsers}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900)),
                        const Text('Online',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                        const Text('Manage Online',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                        width: 80,
                        height: 80,
                        child: FittedBox(
                          child: Icon(
                            Icons.timer,
                            color: Colors.deepPurple[100],
                          ),
                        ))
                  ]),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: <Color>[
                        Color.fromARGB(255, 45, 206, 137),
                        Color.fromARGB(255, 45, 206, 204),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Row(children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 7.0),
                        ),
                        Text('${con.postsNum}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900)),
                        const Text('Posts',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                        const Text('Manage Posts',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                        width: 100,
                        height: 100,
                        child: FittedBox(
                          child: Icon(
                            Icons.newspaper,
                            color: Colors.deepPurple[100],
                          ),
                        ))
                  ]),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: <Color>[
                        Color.fromARGB(255, 94, 114, 228),
                        Color.fromARGB(255, 130, 94, 228),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Row(children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 7.0),
                        ),
                        Text('${con.groupsNum}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900)),
                        const Text('Groups',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                        const Text('Manage Groups',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                        width: 80,
                        height: 100,
                        child: FittedBox(
                          child: Icon(
                            Icons.groups_rounded,
                            color: Colors.deepPurple[100],
                          ),
                        )),
                    const Padding(padding: EdgeInsets.only(left: 7))
                  ]),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: <Color>[
                        Color.fromARGB(255, 94, 114, 228),
                        Color.fromARGB(255, 130, 94, 228),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Row(children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 7.0),
                        ),
                        Text('${con.eventsNum}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900)),
                        const Text('Events',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                        const Text('Manage Events',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    SizedBox(
                        width: 80,
                        height: 80,
                        child: FittedBox(
                          child: Icon(
                            Icons.event_outlined,
                            color: Colors.deepPurple[100],
                          ),
                        ))
                  ]),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: <Color>[
                        Color.fromARGB(255, 43, 255, 198),
                        Color.fromARGB(255, 43, 224, 255),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Row(children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 7.0),
                        ),
                        Text('${con.treasure}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900)),
                        const Text('Treasure balance',
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                      ],
                    ),
                    const Flexible(fit: FlexFit.tight, child: SizedBox()),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minimumSize: const Size(50, 50),
                        maximumSize: const Size(50, 50),
                      ),
                      child: const Icon(
                        Icons.sync,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(right: 10))
                  ]),
                ),
              ],
            ),
          );
  }
}
