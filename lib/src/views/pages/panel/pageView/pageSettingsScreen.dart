import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:shnatter/src/widget/interests.dart';
import 'package:shnatter/src/widget/startedInput.dart';

import '../../../../widget/admin_list_text.dart';

class PageSettingsScreen extends StatefulWidget {
  Function onClick;
  PageSettingsScreen({Key? key, required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;
  @override
  State createState() => PageSettingsScreenState();
}

class PageSettingsScreenState extends mvc.StateMVC<PageSettingsScreen> {
  final TextEditingController pageNameController = TextEditingController();
  final TextEditingController pageUserNameController = TextEditingController();
  final TextEditingController pageCompanyController = TextEditingController();
  final TextEditingController pagePhoneController = TextEditingController();
  final TextEditingController pageWebsiteController = TextEditingController();
  final TextEditingController pageLocationController = TextEditingController();
  final TextEditingController pageAboutController = TextEditingController();
  final TextEditingController pageFacebookController = TextEditingController();
  final TextEditingController pageTwitterController = TextEditingController();
  final TextEditingController pageYoutubeController = TextEditingController();
  final TextEditingController pageInstagramController = TextEditingController();
  final TextEditingController pageTwitchController = TextEditingController();
  final TextEditingController pageLinkedinController = TextEditingController();
  final TextEditingController pageVokonController = TextEditingController();

  var userInfo = UserManager.userInfo;
  var pageSettingTab = 'Page Settings';
  var tabTitle = 'Basic';
  var headerTab;
  var pageInfo;
  var footerBtnState = false;
  var pageInterests;
  List<Map> list = [
    {
      'text': 'Page Settings',
      'icon': Icons.settings,
    },
    {
      'text': 'Page Information',
      'icon': Icons.info_rounded,
    },
    {
      'text': 'Admins',
      'icon': Icons.groups,
    },
    {
      'text': 'Verification',
      'icon': Icons.check_circle,
    },
    {
      'text': 'Interests',
      'icon': Icons.heart_broken,
    },
    {
      'text': 'Delete Page',
      'icon': Icons.delete,
    },
  ];
  List<Map> GroupsDropDown = [
    {
      'value': 'public',
      'title': 'Public Group',
      'subtitle': 'Anyone can see the group, its members and their posts.',
      'icon': Icons.language
    },
    {
      'value': 'closed',
      'title': 'Closed Group',
      'subtitle': 'Only members can see posts.',
      'icon': Icons.lock_open_rounded
    },
    {
      'value': 'secret',
      'title': 'Secret Group',
      'subtitle': 'Only members can find the group and see posts.',
      'icon': Icons.lock_outline_rounded
    },
  ];
  var privacy = 'public';
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    headerTab = [
      {
        'icon': Icons.flag,
        'title': 'Basic',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.attractions,
        'title': 'Action Button',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.facebook,
        'title': 'Social Links',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
    ];
    pageNameController.text = con.page['pageName'];
    pageUserNameController.text = con.page['pageUserName'];
    // pageCompanyController.text = con.page['pageCompany'] ?? '';
    // pagePhoneController.text = con.page['pagePhone'] ?? '';
    // pageWebsiteController.text = con.page['pageWebsite'] ?? '';
    // pageLocationController.text = con.page['pageLocation'] ?? '';
    // pageAboutController.text = con.page['pageAbout'] ?? '';
  }

  late PostController con;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize 
            ?
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LeftSettingBar(),
                Expanded(
                  child: pageSettingTab == 'Page Settings'
                      ? PageSettingsWidget()
                      : pageSettingTab == 'Page Information'
                          ? PageInformationWidget()
                          : pageSettingTab == 'Admins'
                              ? PageAdminsWidget()
                              : pageSettingTab == 'Verification'
                                  ? VerificationWidget()
                                  : pageSettingTab == 'Interests'
                                      ? GroupInterestsWidget()
                                      : GroupDeleteWidget(),
                ),
              ],
            )
            :
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LeftSettingBar(),
                Container(
                  child: pageSettingTab == 'Page Settings'
                      ? PageSettingsWidget()
                      : pageSettingTab == 'Page Information'
                          ? PageInformationWidget()
                          : pageSettingTab == 'Admins'
                              ? PageAdminsWidget()
                              : pageSettingTab == 'Verification'
                                  ? VerificationWidget()
                                  : pageSettingTab == 'Interests'
                                      ? GroupInterestsWidget()
                                      : GroupDeleteWidget(),
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  Widget LeftSettingBar() {
    return Container(
      padding: const EdgeInsets.only(top: 30, right: 20),
      // width: SizeConfig.leftBarAdminWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: list
              .map(
                (e) => ListText(
                  onTap: () => {onClick(e['text'])},
                  label: e['text'],
                  icon: Icon(
                    e['icon'],
                    color: pageSettingTab == e['text']
                        ? Color.fromARGB(255, 94, 114, 228)
                        : Colors.grey,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget PageSettingsWidget() {
    return Container(
      width: SizeConfig(context).screenWidth,
      child: Column(
        children: [
          headerWidget(Icon(Icons.settings), 'Page Settings'),
          Container(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      child: customInput(
                        title: 'Name Your Page',
                        controller: pageNameController,
                        onChange: (value) {},
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 400,
                      child: customInput(
                        title: 'Page UserName',
                        controller: pageUserNameController,
                        onChange: (value) {},
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  width: 380,
                  child: const Text(
                    'Can only contain alphanumeric characters (A–Z, 0–9) and periods (\'.\')',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          footerWidget({
            'pageName': pageNameController.text,
            'pageUserName': pageUserNameController.text,
          })
        ],
      ),
    );
  }

  Widget PageInformationWidget() {
    return Container(
      width: 600,
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.settings),
            pagename: 'Settings',
            button: const {'flag': false},
            headerTab: headerTab,
          ),
          tabTitle == 'Basic'
              ? InfoBasic()
              : tabTitle == 'Action Button'
                  ? InfoButton()
                  : InfoSocialLink(),
          footerWidget(tabTitle == 'Basic'
              ? {
                  'pageCompany': pageCompanyController.text,
                  'pagePhone': pagePhoneController.text,
                  'pageWebsite': pageWebsiteController.text,
                  'pageLocation': pageLocationController.text,
                  'pageAbout': pageAboutController.text,
                }
              : tabTitle == 'Action Button'
                  ? {}
                  : {
                      'pageFacebook': pageFacebookController.text,
                      'pageTwitter': pageTwitterController.text,
                      'pageYoutube': pageYoutubeController.text,
                      'pageInstagram': pageInstagramController.text,
                      'pageTwitch': pageTwitchController.text,
                      'pageLinkedin': pageLinkedinController.text,
                      'pageVokon': pageVokonController.text,
                    })
        ],
      ),
    );
  }

  Widget InfoBasic() {
    return Column(
      children: [
        Container(
          width: 400,
          child: customInput(
            title: 'Company',
            controller: pageCompanyController,
            onChange: (value) {},
          ),
        ),
        Container(
          width: 400,
          child: customInput(
            title: 'Phone',
            controller: pagePhoneController,
            onChange: (value) {},
          ),
        ),
        Container(
          width: 400,
          child: customInput(
            title: 'Website',
            controller: pageWebsiteController,
            onChange: (value) {},
          ),
        ),
        Container(
          width: 400,
          child: customInput(
            title: 'Location',
            controller: pageLocationController,
            onChange: (value) {},
          ),
        ),
        Container(
          width: 400,
          child: customTextarea(
            title: 'About',
            controller: pageAboutController,
            onChange: (value) {},
          ),
        ),
      ],
    );
  }

  Widget InfoSocialLink() {
    return Container(
      width: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
          ? SizeConfig(context).screenWidth * 0.5 + 40
          : SizeConfig(context).screenWidth * 0.9 - 30,
      child: Column(
        children: [
          GridView.count(
            crossAxisCount:
                SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
                    ? 2
                    : 1,
            childAspectRatio: 4 / 1,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 4.0,
            shrinkWrap: true,
            crossAxisSpacing: 4.0,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Facebook Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.1)),
                      child: Icon(
                        Icons.facebook,
                        color: Color.fromARGB(255, 59, 87, 157),
                      ),
                    ),
                    Container(
                      width: 195,
                      height: 30,
                      child: TextFormField(
                        controller: pageFacebookController,
                        onChanged: (newIndex) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 54, 54, 54),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                      ),
                    ),
                  ]),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Twitter Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.1)),
                      child: Icon(
                        Icons.new_releases_sharp,
                        color: Color.fromARGB(255, 59, 87, 157),
                      ),
                    ),
                    Container(
                      width: 195,
                      height: 30,
                      child: TextFormField(
                        controller: pageTwitterController,
                        onChanged: (newIndex) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 54, 54, 54),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                      ),
                    ),
                  ]),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Youtube Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.1)),
                      child: Icon(
                        Icons.facebook,
                        color: Color.fromARGB(255, 59, 87, 157),
                      ),
                    ),
                    Container(
                      width: 195,
                      height: 30,
                      child: TextFormField(
                        controller: pageYoutubeController,
                        onChanged: (newIndex) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 54, 54, 54),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                      ),
                    ),
                  ]),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Instagram Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.1)),
                      child: Icon(
                        Icons.new_releases_sharp,
                        color: Color.fromARGB(255, 59, 87, 157),
                      ),
                    ),
                    Container(
                      width: 195,
                      height: 30,
                      child: TextFormField(
                        controller: pageInstagramController,
                        onChanged: (newIndex) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 54, 54, 54),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                      ),
                    ),
                  ]),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Twitch Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.1)),
                      child: Icon(
                        Icons.youtube_searched_for_sharp,
                        color: Color.fromARGB(255, 59, 87, 157),
                      ),
                    ),
                    Container(
                      width: 195,
                      height: 30,
                      child: TextFormField(
                        controller: pageTwitchController,
                        onChanged: (newIndex) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 54, 54, 54),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                      ),
                    ),
                  ]),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Linkedin Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.1)),
                      child: Icon(
                        Icons.new_releases_sharp,
                        color: Color.fromARGB(255, 59, 87, 157),
                      ),
                    ),
                    Container(
                      width: 195,
                      height: 30,
                      child: TextFormField(
                        controller: pageLinkedinController,
                        onChanged: (newIndex) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 54, 54, 54),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                      ),
                    ),
                  ]),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vokontakte Profile URL',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  Row(children: [
                    Container(
                      width: 40,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 0.1)),
                      child: Icon(
                        Icons.facebook,
                        color: Color.fromARGB(255, 59, 87, 157),
                      ),
                    ),
                    Container(
                      width: 195,
                      height: 30,
                      child: TextFormField(
                        controller: pageVokonController,
                        onChanged: (newIndex) {},
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 54, 54, 54),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        style: const TextStyle(fontSize: 14),
                        onSaved: (String? value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                      ),
                    ),
                  ]),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget InfoButton() {
    return Container();
  }

  Widget customInput({title, onChange, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Color.fromRGBO(82, 95, 127, 1),
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        const Padding(padding: EdgeInsets.only(top: 2)),
        Container(
          height: 40,
          padding: const EdgeInsets.only(top: 5),
          child: TextField(
            controller: controller,
            onChanged: onChange,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget customTextarea({title, onChange, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Color.fromRGBO(82, 95, 127, 1),
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
        const Padding(padding: EdgeInsets.only(top: 2)),
        SizedBox(
          height: 100,
          child: TextField(
            maxLines: 10,
            minLines: 5,
            controller: controller,
            onChanged: onChange,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget PageAdminsWidget() {
    return Container(
      width: 600,
      child: Column(
        children: [
          headerWidget(Icon(Icons.groups), 'Members'),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ADMINS (${con.page["pageAdmin"].length})'),
                SizedBox(
                  width: 450,
                  height: con.page['pageAdmin'].length * 45,
                  child: ListView.separated(
                    itemCount: con.page['pageAdmin'].length,
                    itemBuilder: (context, index) => Material(
                        child: ListTile(
                            onTap: () {
                              print("tap!");
                            },
                            hoverColor:
                                const Color.fromARGB(255, 243, 243, 243),
                            // tileColor: Colors.white,
                            enabled: true,
                            leading: con.page['pageAdmin'][index]['avatar'] ==
                                    ''
                                ? CircleAvatar(
                                    radius: 17,
                                    child: SvgPicture.network(Helper.avatar))
                                : CircleAvatar(
                                    radius: 17,
                                    backgroundImage: NetworkImage(con
                                        .page['pageAdmin'][index]['avatar'])),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        con.page['pageAdmin'][index]
                                            ['userName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(90, 35),
                                            maximumSize: const Size(90, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // const Padding(
                                    //     padding: EdgeInsets.only(left: 10)),
                                    // Container(
                                    //   child: ElevatedButton(
                                    //     style: ElevatedButton.styleFrom(
                                    //         backgroundColor:
                                    //             const Color.fromARGB(
                                    //                 255, 245, 54, 92),
                                    //         elevation: 3,
                                    //         shape: RoundedRectangleBorder(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(2.0)),
                                    //         minimumSize: const Size(125, 35),
                                    //         maximumSize: const Size(125, 35)),
                                    //     onPressed: () {
                                    //       () => {};
                                    //     },
                                    //     child: Row(
                                    //       children: const [
                                    //         Icon(
                                    //           Icons.delete,
                                    //           color: Colors.white,
                                    //           size: 18.0,
                                    //         ),
                                    //         Text('Remove Admin',
                                    //             style: TextStyle(
                                    //                 color: Colors.white,
                                    //                 fontSize: 11,
                                    //                 fontWeight:
                                    //                     FontWeight.bold)),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                )
                              ],
                            ))),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 1,
                      endIndent: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ALL MEMBERS (${con.page["pageLiked"].length})'),
                SizedBox(
                  width: 450,
                  height: con.page['pageLiked'].length * 45,
                  child: ListView.separated(
                    itemCount: con.page['pageLiked'].length,
                    itemBuilder: (context, index) => Material(
                        child: ListTile(
                            onTap: () {
                              print("tap!");
                            },
                            hoverColor:
                                const Color.fromARGB(255, 243, 243, 243),
                            // tileColor: Colors.white,
                            enabled: true,
                            leading: con.page['pageLiked'][index]['avatar'] ==
                                    ''
                                ? CircleAvatar(
                                    radius: 17,
                                    child: SvgPicture.network(Helper.avatar))
                                : CircleAvatar(
                                    radius: 17,
                                    backgroundImage: NetworkImage(con
                                        .page['pageAdmin'][index]['avatar'])),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        con.page['pageLiked'][index]
                                            ['userName'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(90, 35),
                                            maximumSize: const Size(90, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 10)),
                                    Container(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 92),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: const Size(125, 35),
                                            maximumSize: const Size(125, 35)),
                                        onPressed: () {
                                          () => {};
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            Text('Remove Admin',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ))),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 1,
                      endIndent: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget VerificationWidget() {
    return Container(
      width: 600,
      child: Column(
        children: [
          headerWidget(Icon(Icons.check_circle), 'Verification'),
          Container(
            width: SizeConfig(context).screenWidth > SizeConfig.smallScreenSize
                ? SizeConfig(context).screenWidth * 0.5
                : SizeConfig(context).screenWidth * 0.9 - 30,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      width: 100,
                      child: Text(
                        'Chat Message Sound',
                        style: TextStyle(
                            color: Color.fromARGB(255, 82, 95, 127),
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      width: 230,
                      child: Column(
                        children: [
                          Container(
                            width: 230,
                            color: Color.fromARGB(255, 235, 235, 235),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt),
                                  Padding(padding: EdgeInsets.only(left: 20)),
                                  Expanded(
                                      child: Container(
                                    width: 100,
                                    child: Text(
                                      'Your Photo',
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                                ]),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Stack(
                            children: [
                              Container(
                                width: 230,
                                height: 200,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(color: Colors.grey)),
                              ),
                              Container(
                                width: 26,
                                height: 26,
                                margin:
                                    const EdgeInsets.only(top: 150, left: 180),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: Colors.grey[400],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(4),
                                    backgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    minimumSize: const Size(26, 26),
                                    maximumSize: const Size(26, 26),
                                  ),
                                  onPressed: () {
                                    () => {};
                                  },
                                  child: const Icon(
                                      Icons.camera_enhance_rounded,
                                      color: Colors.black,
                                      size: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                    const Padding(padding: EdgeInsets.only(left: 30)),
                    Expanded(
                        child: Container(
                      width: 230,
                      child: Column(
                        children: [
                          Container(
                            width: 230,
                            height: 30,
                            color: Color.fromARGB(255, 235, 235, 235),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.card_membership),
                                  Padding(padding: EdgeInsets.only(left: 20)),
                                  Expanded(
                                      child: Text(
                                    'Passport or National ID',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ))
                                ]),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Stack(
                            children: [
                              Container(
                                width: 230,
                                height: 200,
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    border: Border.all(color: Colors.grey)),
                              ),
                              Container(
                                width: 26,
                                height: 26,
                                margin:
                                    const EdgeInsets.only(top: 150, left: 180),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: Colors.grey[400],
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(4),
                                    backgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                    minimumSize: const Size(26, 26),
                                    maximumSize: const Size(26, 26),
                                  ),
                                  onPressed: () {
                                    () => {};
                                  },
                                  child: const Icon(
                                      Icons.camera_enhance_rounded,
                                      color: Colors.black,
                                      size: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: [
                    const Text(
                      'Chat Message Sound',
                      style: TextStyle(
                          color: Color.fromARGB(255, 82, 95, 127),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 60)),
                    Expanded(
                      child: Container(
                        width: 500,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 250, 250, 250),
                            border: Border.all(color: Colors.grey)),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 4,
                          onChanged: (value) async {
                            // setState(() {});
                          },
                          keyboardType: TextInputType.multiline,
                          style: const TextStyle(fontSize: 12),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: '',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          // footerWidget()
        ],
      ),
    );
  }

  Widget GroupInterestsWidget() {
    return Container(
      width: 600,
      child: Column(
        children: [
          headerWidget(Icon(Icons.heart_broken), 'Interests'),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30),
            child: InterestsWidget(
                context: context,
                data: con.page['pageInterests'],
                sendUpdate: (value) {
                  pageInterests = value;
                  setState(() {});
                }),
          ),
          footerWidget({'pageInterests': pageInterests})
        ],
      ),
    );
  }

  Widget GroupDeleteWidget() {
    return Container(
      width: 600,
      child: Column(
        children: [
          headerWidget(Icon(Icons.delete), 'Delete'),
          Container(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 252, 124, 95),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          children: [
                            const Padding(padding: EdgeInsets.only(left: 30)),
                            const Icon(
                              Icons.warning_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Container(
                                width: 200,
                                child: const Text(
                                  'Once you delete your group you will no longer can access it again',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                          width: 145,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(3),
                                backgroundColor:
                                    const Color.fromARGB(255, 245, 54, 92),
                                // elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0)),
                                minimumSize: const Size(140, 50),
                                maximumSize: const Size(140, 50),
                              ),
                              onPressed: () {
                                (() => {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.delete),
                                  Text('Delete Group',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                                ],
                              ))),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerWidget(icon, pagename) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Color.fromARGB(255, 220, 226, 237),
          width: 1,
        )),
        color: Color.fromARGB(255, 240, 243, 246),
        // borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      padding: const EdgeInsets.only(top: 5, left: 30),
      child: Row(
        children: [
          icon,
          const Padding(padding: EdgeInsets.only(left: 10)),
          Text(pagename),
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
        ],
      ),
    );
  }

  Widget footerWidget(updateData) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(
          color: Color.fromARGB(255, 220, 226, 237),
          width: 1,
        )),
        color: Color.fromARGB(255, 240, 243, 246),
        // borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      padding: const EdgeInsets.only(top: 5, left: 15),
      child: Row(
        children: [
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(3),
                backgroundColor: Colors.white,
                // elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0)),
                minimumSize: const Size(120, 50),
                maximumSize: const Size(120, 50),
              ),
              onPressed: () {
                footerBtnState = true;
                setState(() {});
                con.updatePageInfo(updateData).then(
                      (value) => {
                        footerBtnState = false,
                        setState(() {}),
                      },
                    );
                print({
                  'pageName': pageNameController.text,
                  'pageUserName': pageUserNameController.text,
                  'pageCompany': pageCompanyController.text,
                  'pagePhone': pagePhoneController.text,
                  'pageWebsite': pageWebsiteController.text,
                  'pageLocation': pageLocationController.text,
                  'pageAbout': pageAboutController.text,
                  'pageFacebook': pageFacebookController.text,
                  'pageTwitter': pageTwitterController.text,
                  'pageYoutube': pageYoutubeController.text,
                  'pageInstagram': pageInstagramController.text,
                  'pageTwitch': pageTwitchController.text,
                  'pageLinkedin': pageLinkedinController.text,
                  'pageVokon': pageVokonController.text,
                });
              },
              child: footerBtnState
                  ? const SizedBox(
                      width: 10,
                      height: 10.0,
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                      ),
                    )
                  : const Text('Save Changes',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
          const Padding(padding: EdgeInsets.only(right: 30))
        ],
      ),
    );
  }

  Widget privacySelect(title, content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 30),
              width: SizeConfig(context).screenWidth * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Color.fromRGBO(82, 95, 127, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(content,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
            )),
        const Flexible(fit: FlexFit.tight, child: SizedBox()),
        SizedBox(
          height: 20,
          child: Transform.scale(
            scaleX: 1,
            scaleY: 1,
            child: CupertinoSwitch(
              thumbColor: Colors.white,
              activeColor: Colors.black,
              value: true,
              onChanged: (value) {},
            ),
          ),
        ),
      ],
    );
  }

  onClick(String route) {
    pageSettingTab = route;
    setState(() {});
  }
}
