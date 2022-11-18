
import 'package:flutter/material.dart';
import 'package:shnatter/src/utils/size_config.dart';

// ignore: must_be_immutable
class AdminMainPanel extends StatelessWidget {
  const AdminMainPanel(
      {super.key});
  @override
  Widget build(BuildContext context) {
    return 
    SizeConfig(context).screenWidth >
                                SizeConfig.smallScreenSize ? 
          Container(margin: EdgeInsets.only(top: 0, left: 60, right: 60),
            alignment: Alignment.center,
            child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const Padding(padding: EdgeInsets.only(top: 15.0),),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 280,
                    height: 85,
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
                    child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('76', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Users', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Users', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: FittedBox(child: Icon(
                                  Icons.groups_rounded,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 20.0),),
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 280,
                    height: 85,
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('3', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Online', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Online', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: FittedBox(child: Icon(
                                  Icons.timer,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15.0),),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 280,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: <Color>[
                          Color.fromARGB(255, 245, 54, 92),
                          Color.fromARGB(255, 245, 96, 54),
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('0', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Banned', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Banned', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: FittedBox(child: Icon(
                                  Icons.remove_circle_rounded,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                  const Padding(padding: EdgeInsets.only(left: 20.0),),
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 280,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: <Color>[
                          Color.fromARGB(255, 251, 99, 64),
                          Color.fromARGB(255, 251, 177, 64),
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('3', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Online', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Online', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: FittedBox(child: Icon(
                                  Icons.mail,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15.0),),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 288,
                    height: 85,
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('277', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Posts', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Posts', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: FittedBox(child: Icon(
                                  Icons.newspaper,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                  const Padding(padding: EdgeInsets.only(left: 4.0),),
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 288,
                    height: 85,
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('3', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Online', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Online', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: FittedBox(child: Icon(
                                  Icons.timer,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15.0),),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 190,
                    height: 85,
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('11', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Pages', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Pages', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: FittedBox(child: Icon(
                                  Icons.flag,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                  const Padding(padding: EdgeInsets.only(left: 5.0),),
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 190,
                    height: 85,
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('65', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Groups', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Groups', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 80,
                            height: 100,
                            child: FittedBox(child: Icon(
                                  Icons.groups_rounded,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5.0),),
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 190,
                    height: 85,
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('73', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Events', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Events', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: FittedBox(child: Icon(
                                  Icons.event_outlined,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15.0),),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 288,
                    height: 85,
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('277', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Posts', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Posts', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: FittedBox(child: Icon(
                                  Icons.comment_sharp,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                  const Padding(padding: EdgeInsets.only(left: 4.0),),
                Expanded(
                  flex: 1,
                  child: 
                  Container(
                    width: 288,
                    height: 85,
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('3', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Online', style: TextStyle(color: Colors.white, fontSize: 11)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Manage Online', style: TextStyle(color: Colors.white, fontSize: 10)),
                          ],),
                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: FittedBox(child: Icon(
                                  Icons.blur_circular_outlined,
                                  color: Colors.deepPurple[100],
                                ),)
                          )
                        ]
                      ),
                  ),
                ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15.0),),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: 
                  Container(
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Row(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('230470', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Treasure balance', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],),
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
                          )
                        ]
                      ),
                  ),
                ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 15.0),),
            ],),
          )
          :
          Container(margin: EdgeInsets.only(top: 0, left: 30, right: 30),
            alignment: Alignment.center,
            child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                      width: 280,
                      height: 85,
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
                      child: 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10),),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('76', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Users', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Users', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: FittedBox(child: Icon(
                                    Icons.groups_rounded,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20.0),),
                    Container(
                      width: 280,
                      height: 85,
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
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('3', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Online', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Online', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: FittedBox(child: Icon(
                                    Icons.timer,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                      width: 280,
                      height: 85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            Color.fromARGB(255, 245, 54, 92),
                            Color.fromARGB(255, 245, 96, 54),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                      ),
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('0', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Banned', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Banned', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: FittedBox(child: Icon(
                                    Icons.remove_circle_rounded,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20.0),),
                    Container(
                      width: 280,
                      height: 85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            Color.fromARGB(255, 251, 99, 64),
                            Color.fromARGB(255, 251, 177, 64),
                          ],
                          tileMode: TileMode.mirror,
                        ),
                      ),
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('3', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Online', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Online', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: FittedBox(child: Icon(
                                    Icons.mail,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                      width: 288,
                      height: 85,
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
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('277', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Posts', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Posts', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: FittedBox(child: Icon(
                                    Icons.newspaper,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                      width: 288,
                      height: 85,
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
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('3', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Online', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Online', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: FittedBox(child: Icon(
                                    Icons.timer,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                      width: 288,
                      height: 85,
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
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10),),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('11', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Pages', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Pages', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: FittedBox(child: Icon(
                                    Icons.flag,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                      width: 288,
                      height: 85,
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
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('65', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Groups', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Groups', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 80,
                              height: 100,
                              child: FittedBox(child: Icon(
                                    Icons.groups_rounded,
                                    color: Colors.deepPurple[100],
                                  ),)
                            ),
                            const Padding(padding: EdgeInsets.only(left: 7))
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                      width: 288,
                      height: 85,
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
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('73', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Events', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Events', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: FittedBox(child: Icon(
                                    Icons.event_outlined,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                      width: 288,
                      height: 85,
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
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('277', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Posts', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Posts', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: FittedBox(child: Icon(
                                    Icons.comment_sharp,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                      width: 288,
                      height: 85,
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
                      child: 
                        Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Column(children: const [
                              Padding(padding: EdgeInsets.only(top: 7.0),),
                              Text('3', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Online', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Padding(padding: EdgeInsets.only(top: 5.0),),
                              Text('Manage Online', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],),
                            const Flexible(fit: FlexFit.tight, child: SizedBox()),
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: FittedBox(child: Icon(
                                    Icons.blur_circular_outlined,
                                    color: Colors.deepPurple[100],
                                  ),)
                            )
                          ]
                        ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15.0),),
                    Container(
                    width: 288,
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
                    child: 
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Row(children: const [
                            Padding(padding: EdgeInsets.only(top: 7.0),),
                            Text('230470', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900)),
                            Padding(padding: EdgeInsets.only(top: 5.0),),
                            Text('Treasure balance', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ],),
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
                          )
                        ]
                      ),
                  ),
          ],),
          );
  }
}
