import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/profile/model/friends.dart';
import '../../utils/size_config.dart';
import '../../controllers/ProfileController.dart';

class ProfileFriendScreen extends StatefulWidget {
  Function onClick;
  ProfileFriendScreen(
      {Key? key,
      required this.onClick,
      required this.routerChangeProile,
      required this.profileName})
      : //con = PeopleController(),
        super(key: key);
  //final PeopleController con;
  Function routerChangeProile;
  String profileName;
  @override
  State createState() => ProfileFriendScreenState();
}

class ProfileFriendScreenState extends mvc.StateMVC<ProfileFriendScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  double width = 0;
  double itemWidth = 0;
  var userInfo = UserManager.userInfo;
  var profileCon = ProfileController();
  List<Map> mainInfoList = [];
  Friends friendModel = Friends();
  @override
  void initState() {
    super.initState();
    //add(widget.con);
    //con = controller as PeopleController;

    friendModel.getFriends(profileCon.viewProfileUserName).then((value) {
      setState(() {});
    });
    _gotoHome();
  }

  void _gotoHome() {
    Future.delayed(Duration.zero, () {
      width = SizeConfig(context).screenWidth - 260;
      itemWidth = width / 7.5;
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    // friendModel.getFriends(profileCon.viewProfileUserName).then((value) {
    //   setState(() {});
    // });
    return Container(
        padding:
            const EdgeInsets.only(right: 30, top: 30, bottom: 30, left: 20),
        child: Column(children: [
          mainTabs(),
          isMyFriend() ||
                  ProfileController().viewProfileUid ==
                      UserManager.userInfo['uid']
              ? friendsData()
              : const Text(
                  "You can see the friends data only if you are friends."),
          //: tab == 'Follows'
          //    ? followsData()
          //    : followingsData()
        ]));
  }

  Widget mainTabs() {
    return Container(
      width: SizeConfig(context).screenWidth,
      height: 70,
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
                    Icons.group,
                    size: 14,
                  ),
                  Padding(padding: EdgeInsets.only(left: 5)),
                  Text(
                    'Friends',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget friendsData() {
    var screenWidth = SizeConfig(context).screenWidth;
    return friendModel.friends.isEmpty
        ? Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            height: 200,
            color: Colors.white,
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
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: screenWidth > 800
                      ? 4
                      : screenWidth > 600
                          ? 3
                          : screenWidth > 210
                              ? 2
                              : 1,
                  childAspectRatio: 3 / 3,
                  padding: const EdgeInsets.only(top: 30),
                  mainAxisSpacing: 4.0,
                  shrinkWrap: true,
                  crossAxisSpacing: 4.0,
                  children: friendModel.friends
                      .map((friend) => friendCell(friend))
                      .toList(),
                ),
              ),
            ],
          );
  }

  Widget friendCell(value) {
    var friendUserName = value['requester'];
    if (friendUserName == profileCon.viewProfileUserName) {
      friendUserName = value['receiver'];
    }
    var friendFullName = value[friendUserName]['name'];
    var friendAvatar = value[friendUserName]['avatar'];
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 10),
      width: 200,
      height: 100,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 200,
            height: 100,
            margin: const EdgeInsets.only(top: 60),
            padding: const EdgeInsets.only(top: 70),
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    ProfileController().updateProfile(friendUserName);
                    () => widget.routerChangeProile({
                          'router': RouteNames.profile,
                          'subRouter': friendUserName
                        });
                    setState(() {});
                  },
                  child: Text(friendFullName),
                ),
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              alignment: Alignment.topCenter,
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: Colors.grey)),
              child: friendAvatar != ''
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        friendAvatar,
                      ))
                  : CircleAvatar(
                      radius: 60,
                      child: SvgPicture.network(
                        Helper.avatar,
                        width: 120,
                      ),
                    ),
            ),
            onTap: () {
              ProfileController().updateProfile(friendUserName);
              () => widget.routerChangeProile(
                  {'router': RouteNames.profile, 'subRouter': friendUserName});
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
