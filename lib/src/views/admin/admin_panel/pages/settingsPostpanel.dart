import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/controllers/AdminController.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable

class AdminSettingsPosts extends StatefulWidget {
  AdminSettingsPosts({Key? key})
      : con = AdminController(),
        super(key: key);
  final AdminController con;
  @override
  State createState() => AdminSettingsPostsState();
}

class AdminSettingsPostsState extends mvc.StateMVC<AdminSettingsPosts> {
  String tab = '';
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  List<Map> storiesDropdown = [
    {
      'value': 'everyone',
      'title': 'Everyone',
      'subtitle': 'Any user in the system can',
      'icon': Icons.language
    },
    {
      'value': 'Verified Users',
      'title': 'Verified Users',
      'subtitle': 'Only Admins, Moderators, Pro and Verified Users',
      'icon': Icons.check_circle
    },
    {
      'value': 'Pro Users',
      'title': 'Pro Users',
      'subtitle': 'Any user in the system can',
      'icon': Icons.rocket
    },
    {
      'value': 'Admin',
      'title': 'Admin',
      'subtitle': 'Only Admins and Moderators',
      'icon': Icons.lock
    },
  ];
  List<Map> voiceCoding = [
    {'value': 'mp3', 'title': 'mp3'},
    {'value': 'ogg', 'title': 'ogg'},
    {'value': 'wav', 'title': 'wav'},
  ];
  List<Map> trendingInterval = [
    {'value': 'Last 24Hours', 'title': 'Last 24Hours'},
    {'value': 'Last Week', 'title': 'Last Week'},
    {'value': 'Last Month', 'title': 'Last Month'},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig(context).screenWidth > 700
          ? SizeConfig(context).screenWidth * 0.75
          : SizeConfig(context).screenWidth,
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AdminSettingHeader(
          icon: const Icon(Icons.settings),
          pagename: 'Settings › Posts',
          button: const {'flag': false},
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fstories.svg?alt=media&token=8df62c1f-3007-4f8e-b213-31de7b604902',
            'Stories',
            'Turn the stories On and Off Stories are photos and videos that only last 24 hours'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Story Duration', 30, 1, () {}, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        moduleDropDown('Who Can Add Stories', storiesDropdown, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        moduleDropDown('Newsfeed Posts Source', storiesDropdown,
            'Algorithm will exclude any post from closed/secret groups and events that users not member of incase of all posts also will disable all posts privacy'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fpopular.svg?alt=media&token=7ca882e3-df2c-4fe0-9799-9d82a5da53fd',
            'Popular Posts',
            'Turn the popular posts On and Off Popular posts are public posts ordered by most reactions, comments & shares'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdiscover_post.svg?alt=media&token=00f87033-188d-4b58-a5b5-a5ae3a2a01fb',
            'Discover Posts',
            'Turn the discover posts On and Off Discover posts are public posts ordered from most recent to old'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fmemories.svg?alt=media&token=253f45d8-177f-4eba-9ca6-bb2c28cbb7ff',
            'Memories',
            'Turn the memories On and Off Memories are posts from the same day on last year'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fwall_post.svg?alt=media&token=ed70c783-e4fe-4be0-af0d-094bb88edb0a',
            'Wall Posts',
            'Users can publish posts on their friends walls'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fcolor_post.svg?alt=media&token=f7bd35bb-c568-4383-8d2a-d7f14ca273d8',
            'Colored Posts',
            'Turn the colored posts On and Off Make sure you have configured Colored Posts'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ffeeling_post.svg?alt=media&token=d54ff779-0538-449a-8017-1c9ed5a12d4c',
            'Feelings/Activity Posts',
            'Turn the feelings and activity posts On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fvoice_note.svg?alt=media&token=75f22559-5ac1-40d8-961a-2aebdf6ab76a',
            'Voice Notes in Posts',
            'Turn the voice notes in posts On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fvoice_note.svg?alt=media&token=75f22559-5ac1-40d8-961a-2aebdf6ab76a',
            'Voice Notes in Comments',
            'Turn the voice notes in comments On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Geolocation Google Key', 30, 1, () {},
            'Check the documentation to learn how to get this key'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleDropdown('Voice Notes Encoding', voiceCoding, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fpoll.svg?alt=media&token=e67169b2-93d4-4d46-be1a-2e2c052f32f7',
            'Polls',
            'Turn the poll posts On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgeolocation.svg?alt=media&token=c21265c8-935d-422c-bfa5-2652e6a5a1a4',
            'Geolocation',
            'Turn the post Geolocation On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Geolocation Google Key', 30, 1, () {},
            'Check the documentation to learn how to get this key'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fgif.svg?alt=media&token=0c46bac8-1534-4c6a-8226-0bb287c6cbd0',
            'GIF',
            'Turn the gif posts On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Giphy API Key', 30, 1, () {},
            'Check the documentation to learn how to get this key'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ftraslation.svg?alt=media&token=ef19a65d-e9ff-4d23-8f70-f4d4956baf15',
            'Post Translation',
            'Turn the post translation On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Yandex Key', 30, 1, () {},
            'Check the documentation to learn how to get this key'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fsmart_youtube.svg?alt=media&token=fd3c3f3f-2af7-4ece-9c53-e8c098142b01',
            'Smart YouTube Player',
            'Smart YouTube player will save a lot of bandwidth'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fsocial_share.svg?alt=media&token=984618db-7bc8-4e2c-b822-3b72700b63e3',
            'Social Media Share',
            'Turn the social media share for posts On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Max Post Characters', 30, 1, () {},
            'The Maximum allowed post characters length (0 for unlimited)'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Max Comment Characters', 30, 1, () {},
            'The Maximum allowed comment characters length (0 for unlimited)'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Max Posts/Hour', 30, 1, () {},
            'The Maximum number of posts that user can publish per hour (0 for unlimited)'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Max Comments/Hour', 30, 1, () {},
            'The Maximum number of comments that user can publish per hour (0 for unlimited)'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        moduleDropDown('Default Posts Privacy', storiesDropdown, ''),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fpost_anomous.svg?alt=media&token=571f551c-93c8-4bec-bc48-dce655c4d4e2',
            'Post As Anonymous',
            'Turn Anonymous mode On and Off. Note: Admins and Moderators will able to see the real post author'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fonline_status.svg?alt=media&token=cc7b80cc-e8d7-4ff9-a36e-9c6c439a4658',
            'Online Status on Posts',
            'Turn online indicator on Posts On and Off (User must be online and enabled the chat)'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdesktop_infinity.svg?alt=media&token=19335bba-5298-4d33-abd1-d0512defca3e',
            'Desktop Infinite Scroll',
            'Turn infinite scroll on desktop screens On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fmobile_infiny.svg?alt=media&token=db3da096-52d5-4716-bb6f-cbb9c928fc74',
            'Mobile Infinite Scroll',
            'Turn infinite scroll on mobile screens On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fauto_play.svg?alt=media&token=cca4a40c-f3a0-4adf-965c-20a2c1f291d6',
            'Auto Play Videos',
            'Turn auto play videos On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        const Padding(padding: EdgeInsets.only(top: 20)),
        pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ftrending.svg?alt=media&token=d4f2c06d-f8d3-4c3b-8c1e-5f87cf1672a5',
            'Trending Hashtags',
            'Turn the trending hashtags feature On and Off'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleDropdown('Trending Interval', trendingInterval,
            'Select the interval of trending hashtags'),
        const Padding(padding: EdgeInsets.only(top: 20)),
        titleAndsubtitleInput('Hashtags Limit', 30, 1, () {},
            'How many hashtags you want to display'),
        const AdminSettingFooter()
      ]),
    );
  }

  Widget titleAndsubtitleDropdown(title, List<Map> dropDownItems, subtitle) {
    List items = dropDownItems;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: const TextStyle(
            color: Color.fromRGBO(82, 95, 127, 1),
            fontSize: 13,
            fontWeight: FontWeight.w600),
      ),
      const Padding(padding: EdgeInsets.only(top: 2)),
      SizedBox(
          height: 40,
          width: SizeConfig(context).screenWidth < 900
              ? SizeConfig(context).screenWidth - 60
              : SizeConfig(context).screenWidth * 0.3 - 90,
          child: DropdownButtonFormField(
            value: items[0]['value'],
            items: items
                .map((e) => DropdownMenuItem(
                    value: e['value'], child: Text(e['title'])))
                .toList(),
            onChanged: (value) {},
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 10),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
            icon: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.arrow_drop_down)),
            iconEnabledColor: Colors.grey, //Icon color

            style: const TextStyle(
              color: Colors.grey, //Font color
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            dropdownColor: Colors.white,
            isExpanded: true,
            isDense: true,
          ))
    ]);
  }

  Widget moduleDropDown(title, List<Map> dropDownItems, subTitle) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 85, 95, 127)),
            ),
          ),
          Expanded(
              flex: 2,
              child: SizedBox(
                width: 500,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 400,
                        height: 70,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 250, 250),
                            border: Border.all(color: Colors.grey)),
                        child: DropdownButton(
                          value: dropDownItems[0]['value'],
                          itemHeight: 70,
                          items: dropDownItems
                              .map((e) => DropdownMenuItem(
                                  value: e['value'],
                                  child: SizedBox(
                                      height: 70,
                                      child: ListTile(
                                        leading: Icon(e['icon']),
                                        title: Text(e['title']),
                                        subtitle: Text(e['subtitle']),
                                      ))))
                              .toList(),
                          onChanged: (value) {
                            //get value when changed
                            // dropdownValue = value!;
                            setState(() {});
                          },
                          icon: const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Icon(Icons.arrow_drop_down)),
                          iconEnabledColor: Colors.white, //Icon color
                          style: const TextStyle(
                            color: Colors.black, //Font color
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          dropdownColor: Colors.white,
                          underline: Container(), //remove underline
                          isExpanded: true,
                          isDense: true,
                        ),
                      ),
                      SizedBox(
                        width: 400,
                        child: Text(subTitle),
                      )
                    ]),
              ))
        ],
      ),
    );
  }

  Widget pictureAndSelect(svgSource, title, content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.network(
          svgSource,
          width: 40,
        ),
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
                    style: TextStyle(
                        color: fontColor,
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

  Widget titleAndsubtitleInput(title, height, line, onChange, subTitle) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 85, 95, 127)),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: 400,
                  child: Column(children: [
                    TextField(
                      maxLines: line,
                      minLines: line,
                      onChanged: (value) {
                        onChange(value);
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 10, left: 10),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                    ),
                    Text(subTitle)
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
