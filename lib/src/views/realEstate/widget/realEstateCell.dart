// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/alertYesNoWidget.dart';
import 'package:shnatter/src/widget/createRealEstateWidget.dart';
import 'package:shnatter/src/widget/likesCommentWidget.dart';
import 'package:shnatter/src/views/messageBoard/messageScreen.dart';

// ignore: must_be_immutable
class RealEstateCell extends StatefulWidget {
  RealEstateCell({
    super.key,
    required this.data,
    required this.routerChange,
    this.isShared = false,
  }) : con = PostController();
  var data;
  var isShared = false;
  Function routerChange;
  late PostController con;
  @override
  State createState() => RealEstateCellState();
}

class RealEstateCellState extends mvc.StateMVC<RealEstateCell> {
  late PostController con;
  var realEstate;
  Map realEstateAdmin = {};
  var realEstateId = '';
  bool payLoading = false;
  bool loading = false;
  var postTime = '';
  var messsageScreen = MessageScreenState();

  List<Map> popupMenuItem = [
    {
      'icon': Icons.edit,
      'label': 'Edit Real Estate',
      'value': 'edit',
    },
    {
      'icon': Icons.delete,
      'label': 'Delete Real Estate',
      'value': 'delete',
    },
    {
      'icon': Icons.remove_red_eye_sharp,
      'label': 'Hide from Timeline',
      'labelE': 'Allow on Timeline',
      'value': 'timeline',
    },
    {
      'icon': Icons.chat_bubble,
      'label': 'Turn off Commenting',
      'labelE': 'Turn on Commenting',
      'value': 'comment',
    },
    {
      'icon': Icons.link,
      'label': 'Open post in new tab',
      'value': 'open',
    },
  ];

  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    getData();
  }

  Future<void> getData() async {
    // if (!mounted) return;

    print("widget.data ============${widget.data}");
    widget.data['type'] = 'realestate';

    realEstate = widget.data['data'];
    realEstateAdmin = widget.data['adminInfo'];
    realEstateId = widget.data['id'];
    postTime = con.timeAgo(realEstate['realEstateDate']);
    setState(() {});
  }

  buyRealEstate() async {
    var eventAdminInfo = await ProfileController()
        .getUserInfo(realEstate['realEstateAdmin']['uid']);
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(),
        content: AlertYesNoWidget(
            yesFunc: () async {
              payLoading = true;
              setState(() {});

              await UserController()
                  .payShnToken(eventAdminInfo!['paymail'].toString(),
                      realEstate['realEstatePrice'], 'Pay for buy real estate')
                  .then(
                    (value) async => {
                      if (value = true)
                        {
                          await FirebaseFirestore.instance
                              .collection("transaction")
                              .add({
                            'seller': {
                              'userName': eventAdminInfo['userName'],
                              'email': eventAdminInfo['email'],
                              'avatar': eventAdminInfo['avatar'],
                            },
                            'buyer': {
                              'userName': UserManager.userInfo['userName'],
                              'email': UserManager.userInfo['email'],
                              'avatar': UserManager.userInfo['avatar'],
                            },
                            'realestate': realEstate
                          }),
                          payLoading = false,
                          setState(() {}),
                          Navigator.of(context).pop(true),
                          loading = true,
                          setState(() {}),
                          await con.changeRealEstateSellState(realEstateId),
                          loading = false,
                          setState(() {}),
                        }
                      else
                        {
                          payLoading = false,
                          setState(() {}),
                          Navigator.of(context).pop(true),
                          setState(() {}),
                          loading = true,
                          setState(() {})
                        }
                    },
                  );
            },
            noFunc: () async {
              Navigator.of(context).pop(true);
            },
            header: 'Pay Token',
            text: 'Are you sure about pay token',
            progress: payLoading),
      ),
    );
  }

  popUpFunction(value) async {
    switch (value) {
      case 'edit':
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Row(
              children: const [
                Icon(
                  Icons.production_quantity_limits_sharp,
                  color: Color.fromARGB(255, 33, 150, 243),
                ),
                Text(
                  'Add New Real Estate',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
            content: CreateRealEstateModal(
              context: context,
              routerChange: widget.routerChange,
              editData: widget.data,
            ),
          ),
        );
        setState(() {});
        break;
      case 'delete':
        deleteRealEstateInfo();
        break;
      case 'timeline':
        hideFromTimeline();
        break;
      case 'comment':
        upDateRealEstateInfo({
          'realEstateOnOffCommenting': !realEstate['realEstateOnOffCommenting']
        });
        realEstate['realEstateOnOffCommenting'] =
            !realEstate['realEstateOnOffCommenting'];
        setState(() {});
        break;
      case 'open':
        widget.routerChange({
          'router': RouteNames.realEstate,
          'subRouter': realEstateId,
        });
        break;
      default:
    }
  }

  upDateRealEstateInfo(value) async {
    con.updateRealEstateInfo(realEstateId, value);
  }

  deleteRealEstateInfo() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(),
        content: AlertYesNoWidget(
            yesFunc: () async {
              con.deleteRealEstate(realEstateId);
              Navigator.of(context).pop(true);
            },
            noFunc: () {
              Navigator.of(context).pop(true);
            },
            header: 'Delete Real Estate',
            text: 'Are you sure you want to delete this real estate?',
            progress: false),
      ),
    );
  }

  hideFromTimeline() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const SizedBox(),
        content: AlertYesNoWidget(
            yesFunc: () async {
              upDateRealEstateInfo(
                  {'realEstateTimeline': !realEstate['realEstateTimeline']});
              realEstate['realEstateTimeline'] =
                  !realEstate['realEstateTimeline'];
              setState(() {});
              Navigator.of(context).pop(true);
            },
            noFunc: () {
              Navigator.of(context).pop(true);
            },
            header: 'Hide from Timeline',
            text:
                'Are you sure you want to hide this real estate from your profile timeline? It may still appear in other places like newsfeed and search results',
            progress: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return realEstate['realEstateTimeline'] == false
        ? DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            dashPattern: [10, 10],
            color: Colors.grey,
            strokeWidth: 2,
            child: realEstateWidget(),
          )
        : realEstateWidget();
  }

  Widget realEstateWidget() {
    return Row(
      children: [
        Expanded(
            child: Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          width: 600,
          padding: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: widget.isShared
                ? Border.all(color: Colors.blueAccent)
                : Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      realEstateAdmin == null
                          ? const SizedBox(
                              child: Text('No Owenr'),
                            )
                          : Row(
                              children: [
                                realEstateAdmin['avatar'] != ''
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                        realEstateAdmin['avatar'],
                                      ))
                                    : CircleAvatar(
                                        child:
                                            SvgPicture.network(Helper.avatar),
                                      ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        '${realEstateAdmin['firstName']!} ${realEstateAdmin['lastName']!}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            print('username');
                                                            ProfileController()
                                                                .updateProfile(
                                                                    realEstateAdmin[
                                                                        'userName']!);
                                                            widget
                                                                .routerChange({
                                                              'router':
                                                                  RouteNames
                                                                      .profile,
                                                              'subRouter':
                                                                  realEstateAdmin[
                                                                      'userName']!,
                                                            });
                                                          })
                                              ]),
                                        ),
                                        SizedBox(
                                          width:
                                              SizeConfig(context).screenWidth <
                                                      600
                                                  ? SizeConfig(context)
                                                          .screenWidth -
                                                      340
                                                  : 350,
                                          child: Text(
                                            ' added new real estate for ${realEstate["realEstateOffer"]}',
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Visibility(
                                          visible: !widget.isShared,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                right: 9.0),
                                            child: PopupMenuButton(
                                              onSelected: (value) {
                                                popUpFunction(value);
                                              },
                                              child: const Icon(
                                                Icons.arrow_drop_down,
                                                size: 18,
                                              ),
                                              itemBuilder: (BuildContext bc) {
                                                return popupMenuItem
                                                    .map(
                                                      (e) => PopupMenuItem(
                                                        value: e['value'],
                                                        child: Row(
                                                          children: [
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5.0)),
                                                            Icon(e['icon']),
                                                            const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            12.0)),
                                                            Text(
                                                              e['value'] ==
                                                                      'timeline'
                                                                  ? realEstate[
                                                                          'realEstateTimeline']
                                                                      ? e[
                                                                          'label']
                                                                      : e[
                                                                          'labelE']
                                                                  : e['value'] ==
                                                                          'comment'
                                                                      ? realEstate[
                                                                              'realEstateOnOffCommenting']
                                                                          ? e['label']
                                                                          : e['labelE']
                                                                      : e['label'],
                                                              style: const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          90,
                                                                          90,
                                                                          90),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize: 12),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 3)),
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                                text: postTime,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        widget.routerChange({
                                                          'router': RouteNames
                                                              .realEstate,
                                                          'subRouter':
                                                              realEstateId,
                                                        });
                                                      })
                                          ]),
                                        ),
                                        const Text(' - '),
                                        const Icon(
                                          Icons.language,
                                          color: Colors.grey,
                                          size: 12,
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                      const Padding(padding: EdgeInsets.only(top: 15)),
                      Text(
                        realEstate['realEstateName'],
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 20,
                          ),
                          Text(
                            realEstate['realEstateLocation'] ?? '',
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          realEstate['realEstateAbout'] ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      Container(
                        height: 78,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 247, 247),
                          border: Border.all(
                              color: const Color.fromARGB(255, 229, 229, 229)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      const Text(
                                        'Offer',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      Text(
                                        'For ${realEstate['realEstateOffer']}',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ]),
                                  )),
                              Container(
                                width: 1,
                                height: 60,
                                color: const Color.fromARGB(255, 229, 229, 229),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.sell,
                                            color: Color.fromARGB(
                                                255, 31, 156, 255),
                                            size: 17,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 1)),
                                          Text(
                                            'Condition',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.fade,
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      Text(
                                        '${realEstate['realEstateStatus']}',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ]),
                                  )),
                              Container(
                                width: 1,
                                height: 60,
                                color: const Color.fromARGB(255, 229, 229, 229),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.money,
                                            color: Color.fromARGB(
                                                255, 43, 180, 40),
                                            size: 17,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5)),
                                          Text(
                                            'Price',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      Text(
                                        '${realEstate['realEstatePrice']} (SHN)',
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ]),
                                  )),
                              Container(
                                width: 1,
                                height: 60,
                                color: const Color.fromARGB(255, 229, 229, 229),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(children: [
                                      const Padding(
                                          padding: EdgeInsets.only(top: 20)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.gif_box,
                                            color: Color.fromARGB(
                                                255, 160, 56, 178),
                                            size: 17,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5)),
                                          Text(
                                            'Status',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 90,
                                        height: 25,
                                        decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 40, 167, 69),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: const Text(
                                          'In Stock',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      )
                                    ]),
                                  )),
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: UserManager.userInfo['userName'] ==
                                      realEstateAdmin['userName']
                                  ? 0
                                  : 30)),
                      UserManager.userInfo['uid'] ==
                              realEstate['realEstateAdmin']['uid']
                          ? Container()
                          : SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 17, 205, 239),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                  ),
                                  onPressed: () async {
                                    widget.routerChange({
                                      'router': RouteNames.messages,
                                      'subRouter': widget.data["data"]
                                              ["realEstateAdmin"]["uid"]
                                          .toString()
                                    });

                                    setState(() {});
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.wechat_outlined),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10)),
                                      Text(
                                        'Contact',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      UserManager.userInfo['uid'] ==
                              realEstate['realEstateAdmin']['uid']
                          ? Container()
                          : SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 240, 96, 63),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                  ),
                                  onPressed: () async {
                                    buyRealEstate();
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.wechat_outlined),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10)),
                                      Text(
                                        'Buy',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )),
                            ),
                    ]),
              ),
              Visibility(
                  visible: !widget.isShared,
                  child: LikesCommentScreen(
                    postInfo: widget.data,
                    commentFlag: realEstate['realEstateOnOffCommenting'],
                    routerChange: widget.routerChange,
                  )),
              const Padding(padding: EdgeInsets.only(top: 10)),
            ],
          ),
        ))
      ],
    );
  }
}
