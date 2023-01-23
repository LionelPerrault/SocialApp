import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/messageBoard/widget/chatMessageListScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/chatScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/chatUserListScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/newMessageScreen.dart';
import 'package:shnatter/src/views/messageBoard/widget/writeMessageScreen.dart';
import 'package:shnatter/src/views/products/widget/productcell.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/views/navigationbar.dart';

import '../../controllers/ChatController.dart';
import '../../utils/size_config.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({Key? key})
      : con = ChatController(),
        super(key: key);
  ChatController? con;
  @override
  State createState() => MessageScreenState();
}

class MessageScreenState extends mvc.StateMVC<MessageScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  bool isShowChatUserList = false;
  bool isCheckConnect = true;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  //route variable
  String pageSubRoute = '';

  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    super.initState();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    setState(() { });
  }

  late ChatController con;
  void onSearchBarFocus() {
    searchFocusNode.requestFocus();
    setState(() {
      showSearch = true;
    });
  }

  void clickMenu() {
    //setState(() {
    //  showMenu = !showMenu;
    //});
    //Scaffold.of(context).openDrawer();
    //print("showmenu is {$showMenu}");
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  void onSearchBarDismiss () {
    if (showSearch)
      setState(() {
        showSearch = false;
      });
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void connectFrom(uidOfTarget) async {
    await con.connectFromMarketPlace(uidOfTarget);
    isCheckConnect = false;
    con.setState(() { });
    setState(() { });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    _drawerSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {
    if(isCheckConnect){
      final uidOfTarget = ModalRoute.of(context)!.settings.arguments;
      if(uidOfTarget != null){
        connectFrom(uidOfTarget);
        // print("$uidOfTarget................zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
      }
    }
    
    return MobileScreen();
  }

  Widget MobileScreen() {
    return Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
            ),
            Padding(
              padding: EdgeInsets.only(top: SizeConfig.navbarHeight),
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: SizeConfig(context).screenWidth,
                      height: SizeConfig(context).screenHeight - SizeConfig.navbarHeight,
                      child: SingleChildScrollView(
                        child: Column(children: [
                          con.isMessageTap == 'all-list' 
                          ? 
                          NewMessageScreen(onBack: (value) {
                            if(value == true || value == false){
                              isShowChatUserList = value;
                            }else{
                              con.isMessageTap = value;
                            }
                            con.setState(() {});
                            setState(() {});
                          }) 
                          : ChatScreenHeader(),
                          
                          con.isMessageTap == 'all-list'
                            ? isShowChatUserList 
                              ? const SizedBox() 
                              : ChatUserListScreen(onBack: (value) {
                                con.isMessageTap = value;
                                con.setState(() {});
                                setState(() {});
                              })
                            : con.isMessageTap == 'new'
                                ? 
                                Padding(
                                  padding: EdgeInsets.only(top: SizeConfig(context).screenHeight - 220),
                                  child: WriteMessageScreen(
                                    type: 'new',
                                    goMessage: (value) {
                                      con.isMessageTap = value;
                                      if(value == 'message-list'){
                                        isShowChatUserList = false;
                                      }
                                      setState(() { });
                                      con.setState(() { });
                                    },
                                  ),
                                )
                                : ChatMessageListScreen(
                                    showWriteMessage: true,
                                    onBack: (value) {
                                      con.isShowEmoticon = value;
                                      setState(() {});
                                    },
                                  )
                        ])
                      ),
                    ),
                  ],
                ),
              ),
            ),
            showSearch
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showSearch = false;
                      });
                    },
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color.fromARGB(0, 214, 212, 212),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 9),
                                  width: SizeConfig(context).screenWidth * 0.4,
                                  child: TextField(
                                    focusNode: searchFocusNode,
                                    controller: searchController,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.search,
                                          color: Color.fromARGB(
                                              150, 170, 212, 255),
                                          size: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xff202020),
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  )
                : const SizedBox(),
          ],
        ));
  }

  // ignore: non_constant_identifier_names
  Widget ChatScreenHeader() {
    return SizedBox(
      width: SizeConfig(context).screenWidth,
      height: 60,
      child: Column(
        children: [
          AppBar(
          toolbarHeight: 60,
          backgroundColor: const Color.fromRGBO(51, 103, 214, 1),
          automaticallyImplyLeading: false,
          leading: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  isShowChatUserList = false;
                  con.isMessageTap = 'all-list';
                  con.setState(() {});
                  setState(() {});
              }),
              SizedBox(
                      width: 46,
                      height: 46,
                      child: con.avatar == ''
                          ? CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.blue,
                              child: SvgPicture.network(Helper.avatar))
                          : CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.blue,
                              backgroundImage:
                                  NetworkImage(con.avatar),
                          ),
                    ),
                    Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5),
                    child: Text(
                      con.chatUserFullName,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
            ])
          ) 
        ],
      )
    );
  }
}
