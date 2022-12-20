import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminGenders extends StatefulWidget {
  AdminGenders({super.key});

  @override
  State createState() => AdminGendersState();
}

class AdminGendersState extends mvc.StateMVC<AdminGenders> {
  @override
  void initState() {
    super.initState();
  }

  bool check1 = false;
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  double fontSize = 14;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AdminSettingHeader(
            icon: const Icon(Icons.settings),
            pagename: 'Settings',
            button: const {'flag': false},
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: SizeConfig(context).screenWidth > 800
                ? SizeConfig(context).screenWidth * 0.75
                : SizeConfig(context).screenWidth,
            child: generalWidget(),
          ),
        ],
      ),
    );
  }

  Widget generalWidget() {
    return Container(
      child: Column(
        children: [
          pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fdesign%2FnightAndDark.svg?alt=media&token=017921a8-d7b2-4557-83bf-d4b8a298ec3d',
            'Night Mode is Default',
            'Make the night mode is the default mode of your website',
          ),
          pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fdesign%2FuserCanChange.svg?alt=media&token=eb2a8046-5bde-4183-964d-ac97bff9f429',
            'Users Can Change Mode',
            'Allow users to select between day and night mode',
          ),
          const Divider(thickness: 0.1, color: Colors.black),
          titleAndUpload('Website Logo'),
          const Divider(thickness: 0.1, color: Colors.black),
          pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fdesign%2FdefaultWallPaper.svg?alt=media&token=7f494266-da0b-41cd-97fd-89d1d22cae4b',
            'Default Home Wallpaper',
            'Use the default (Disable it to use your custom uploaded image)',
          ),
          titleAndUpload('Custom Home Wallpaper'),
          const Divider(thickness: 0.1, color: Colors.black),
          pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fdesign%2FdefaultFavicon.svg?alt=media&token=1ce486ec-9d9c-4307-8a3b-d0c5dab10568',
            'Default Favicon',
            'Use the default (preview) (Disable it to use your custom uploaded image)',
          ),
          titleAndUpload('Custom Favicon'),
          const Divider(thickness: 0.1, color: Colors.black),
          pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fdesign%2FdefaultOGImage.svg?alt=media&token=b6dc2b45-fbd6-4d7d-b800-6b445d74f1b8',
            'Default OG-Image',
            'Use the default (preview) (Disable it to use your custom uploaded image)',
          ),
          titleAndUpload('Custom OG-Image'),
          const Divider(thickness: 0.1, color: Colors.black),
          pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fdesign%2FgooglePlay.svg?alt=media&token=468a60a7-7e58-4aec-979f-7efb83c9e972',
            'Google Play Store Badge',
            'Show Google Play Store badge on the landing page',
          ),
          titleAndsubtitleInput('Google Play Store Link', 30, 1,
              'The app link on Google Play Store'),
          const Divider(thickness: 0.1, color: Colors.black),
          pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fdesign%2FhuwaiApp.svg?alt=media&token=53a34099-d2d9-42f4-b50c-c7435ba61a76',
            'Huawei AppGallery Badge',
            'Show Huawei AppGallery badge on the landing page',
          ),
          titleAndsubtitleInput('Huawei AppGallery Link', 30, 1,
              'The app link on Huawei AppGallery'),
          const Divider(thickness: 0.1, color: Colors.black),
          pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fdesign%2FappleApp.svg?alt=media&token=1154451d-302e-4b71-a8df-a3f6da5c9d28',
            'Apple App Store Badge',
            'Show Apple App Store badge on the landing page',
          ),
          titleAndsubtitleInput(
              'Apple App Store Link', 30, 1, 'The app link on Apple App Store'),
          const Divider(thickness: 0.1, color: Colors.black),
          pictureAndSelect(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fdesign%2FenableCustom.svg?alt=media&token=54c3d664-771f-40a3-a665-3f7bdf5bb44a',
            'Enable Customization',
            'Turn the customization On and Off',
          ),
          titleAndsubtitleInput('Background Color', 30, 1, ''),
          titleAndsubtitleInput('Link Color', 30, 1, ''),
          titleAndsubtitleInput('Header Color', 30, 1, ''),
          titleAndsubtitleInput('Header Search Background', 30, 1, ''),
          titleAndsubtitleInput('Header Search Font', 30, 1, ''),
          titleAndsubtitleInput('Button Primary', 30, 1, ''),
          titleAndsubtitleInput('Custom CSS', 150, 7, 'Header Custom CSS'),
          titleAndsubtitleInput('Header Custom JavaScript', 100, 7,
              'The code will be added in head tag'),
          titleAndsubtitleInput('Footer Custom JavaScript', 100, 7,
              'The code will be added at the end of body tag'),
          const Padding(padding: EdgeInsets.only(top: 10)),
          footer()
        ],
      ),
    );
  }

  Widget footer() {
    return Container(
        height: 80,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(240, 240, 240, 1),
            border: Border(top: BorderSide(width: 0.5, color: Colors.grey))),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(2.0)),
            minimumSize: const Size(150, 50),
            maximumSize: const Size(150, 50),
          ),
          onPressed: () {
            () => {};
          },
          child: const Text('Save Changes',
              style: TextStyle(
                  color: Color.fromARGB(255, 33, 37, 41),
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold)),
        ));
  }

  Widget moduleDropDown(title, List<Map> dropDownItems) {
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
                                  child: Container(
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
                    ]),
              ))
        ],
      ),
    );
  }

  Widget titleAndsubtitleInput(title, height, line, subtitle) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
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
                        height: height,
                        child: TextField(
                          maxLines: line,
                          minLines: line,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 10, left: 10),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ]),
              ))
        ],
      ),
    );
  }

  Widget pictureAndSelect(svgSource, title, content) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
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
                padding: EdgeInsets.only(left: 10, right: 30),
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
                        style: TextStyle(fontSize: 13)),
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
      ),
    );
  }

  Widget titleAndUpload(title) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: fontColor, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Flexible(
            fit: FlexFit.tight,
            child: SizedBox(),
          ),
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 70, left: 70),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    backgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    minimumSize: const Size(30, 30),
                    maximumSize: const Size(30, 30),
                  ),
                  onPressed: () {},
                  child: const Icon(Icons.camera_enhance_rounded,
                      color: Colors.black, size: 16.0),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
