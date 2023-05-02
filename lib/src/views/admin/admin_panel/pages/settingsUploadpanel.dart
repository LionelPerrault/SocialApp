import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shnatter/src/utils/size_config.dart';

import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingsUpload extends StatefulWidget {
  const AdminSettingsUpload({super.key});

  @override
  State createState() => AdminSettingsUploadState();
}

class AdminSettingsUploadState extends mvc.StateMVC<AdminSettingsUpload> {
  @override
  void initState() {
    super.initState();
    headerTab = [
      {
        'icon': FontAwesomeIcons.upload,
        'title': 'General',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': Icons.ac_unit,
        'title': 'Amazon S3',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': FontAwesomeIcons.digitalOcean,
        'title': 'DigitalOcean',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': FontAwesomeIcons.digitalOcean,
        'title': 'Wasabi',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
      {
        'icon': FontAwesomeIcons.cloudUpload,
        'title': 'FTP',
        'onClick': (value) {
          tabTitle = value;
          setState(() {});
        }
      },
    ];
  }

  List<Map> photoQualityItems = [
    {
      'title': 'High Quality',
      'value': 'High Quality',
      'subtitle': 'High quality photos with low compression',
      'icon': Icons.battery_1_bar
    },
    {
      'title': 'Medium Quality',
      'value': 'Medium Quality',
      'subtitle': 'Medium quality photos with medium compression',
      'icon': Icons.battery_1_bar
    },
    {
      'title': 'Low Quality',
      'value': 'Low Quality',
      'subtitle': 'Low quality photos with high compression',
      'icon': Icons.battery_1_bar
    }
  ];
  List<Map> spaceRegionItems = [
    {
      'title': 'San Francisco 2',
      'value': 'San Francisco 2',
    },
    {
      'title': 'San Francisco 3',
      'value': 'San Francisco 3',
    },
    {
      'title': 'New York',
      'value': 'New York',
    },
    {
      'title': 'Amsterdam',
      'value': 'Amsterdam',
    },
    {
      'title': 'Singapore',
      'value': 'Singapore',
    },
    {
      'title': 'Frankfurt',
      'value': 'Frankfurt',
    },
  ];
  List<Map> bucketRegionItems = [
    {
      'title': 'us-west-1',
      'value': 'us-west-1',
    },
    {
      'title': 'ap-northeast-1',
      'value': 'ap-northeast-1',
    },
    {
      'title': 'ap-northeast-2',
      'value': 'ap-northeast-2',
    },
    {
      'title': 'eu-central-1',
      'value': 'eu-central-1',
    },
    {
      'title': 'eu-west-1',
      'value': 'eu-west-1',
    },
    {
      'title': 'us-central-1',
      'value': 'us-central-1',
    },
    {
      'title': 'us-east-1',
      'value': 'us-east-1',
    },
    {
      'title': 'us-east-2',
      'value': 'us-east-2',
    },
  ];
  bool check1 = false;
  Color fontColor = const Color.fromRGBO(82, 95, 127, 1);
  double fontSize = 14;
  String tabTitle = 'General';
  late var headerTab;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminSettingHeader(
          icon: const Icon(Icons.settings),
          pagename: 'Settings › Notifications',
          button: const {'flag': false},
          headerTab: headerTab,
        ),
        Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: SizeConfig(context).screenWidth < 700
                ? SizeConfig(context).screenWidth
                : SizeConfig(context).screenWidth * 0.75,
            child: tabTitle == 'General'
                ? generalWidget()
                : tabTitle == 'Amazon S3'
                    ? amazonWidget()
                    : tabTitle == 'DigitalOcean'
                        ? digitalOceanWidget()
                        : tabTitle == 'Wasabi'
                            ? wasabiWidget()
                            : ftpWidget())
      ],
    );
  }

  Widget ftpWidget() {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(120, 137, 232, 1),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Row(children: [
          const Icon(
            Icons.cloud_upload,
            size: 30,
          ),
          const Padding(padding: EdgeInsets.only(left: 15)),
          SizedBox(
              width: SizeConfig(context).screenWidth * 0.5,
              child: Text(
                "FTP Storage Before enabling FTP Storage, make sure you upload the whole 'uploads' folder to your space. Before disabling FTP Storage, make sure you download the whole 'uploads' folder to your server.",
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ))
        ]),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fcloudupload.svg?alt=media&token=b3153b3d-2747-47c5-a960-6677409af4e8',
          'FTP Storage',
          'Enable FTP Storage upload (Note: Enable this will disable all other options)'),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      titleAndsubtitleInput('Hostname', 30, 1, ''),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleDropdown('Port', bucketRegionItems, ''),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Username', 30, 1, ''),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Password', 30, 1, ''),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('FTP Path', 30, 1,
          "The path to your uploads folder (Examples: './' or 'public_html/uploads')"),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('FTP Endpoint', 30, 1,
          "The URL to your uploads folder (Examples: 'https://domain.com/uploads' or 'https://64.233.191.255/uploads')"),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      uploadFotter()
    ]);
  }

  Widget wasabiWidget() {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(120, 137, 232, 1),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Row(children: [
          SvgPicture.network(
            'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fwasabi.svg?alt=media&token=d06b96a0-8a09-4f37-b9db-65865c3368f7',
            width: 30,
          ),
          const Padding(padding: EdgeInsets.only(left: 15)),
          SizedBox(
              width: SizeConfig(context).screenWidth * 0.5,
              child: Text(
                "Wasabi Before enabling Wasabi, make sure you upload the whole 'uploads' folder to your bucket. Before disabling Wasabi, make sure you download the whole 'uploads' folder to your server.",
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ))
        ]),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fwasabi.svg?alt=media&token=d06b96a0-8a09-4f37-b9db-65865c3368f7',
          'Wasabi',
          'Enable Wasabi storage (Note: Enable this will disable all other options)'),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      titleAndsubtitleInput('Bucket Name', 30, 1, 'Your Wasabi bucket name'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleDropdown(
          'Bucket Region', bucketRegionItems, 'Your Wasabi bucket region'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Access Key ID', 30, 1, 'Your Wasabi Access Key ID'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Access Key Secret', 30, 1, 'Your Wasabi Access Key Secret'),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      uploadFotter()
    ]);
  }

  Widget digitalOceanWidget() {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(120, 137, 232, 1),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Row(children: [
          const Icon(
            FontAwesomeIcons.digitalOcean,
            color: Colors.white,
            size: 30,
          ),
          const Padding(padding: EdgeInsets.only(left: 15)),
          SizedBox(
              width: SizeConfig(context).screenWidth * 0.5,
              child: Text(
                "DigitalOcean Before enabling DigitalOcean Space, make sure you upload the whole 'uploads' folder to your space. Before disabling DigitalOcean Space, make sure you download the whole 'uploads' folder to your server.",
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ))
        ]),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Famazon.svg?alt=media&token=537392f0-28b2-426a-81d9-fa54d9ac060e',
          'DigitalOcean Space',
          'Enable DigitalOcean storage (Note: Enable this will disable all other options)'),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      titleAndsubtitleInput(
          'Space Name', 30, 1, 'Your DigitalOcean space name'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleDropdown(
          'Space Region', spaceRegionItems, 'Your DigitalOcean space region'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Access Key ID', 30, 1, 'Your DigitalOcean Access Key ID'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Access Key Secret', 30, 1, 'Your DigitalOcean Access Key Secret'),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      uploadFotter()
    ]);
  }

  Widget uploadFotter() {
    return Container(
        height: 80,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(240, 240, 240, 1),
            border: Border(top: BorderSide(width: 0.5, color: Colors.grey))),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 15),
        child: Row(children: [
          const Flexible(fit: FlexFit.tight, child: SizedBox()),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(245, 54, 92, 1),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                minimumSize: const Size(200, 50),
                maximumSize: const Size(200, 50),
              ),
              onPressed: () {
                () => {};
              },
              child: const Text('Test Connection (Vision API)',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.0,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Expanded(
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
          ))
        ]));
  }

  Widget generalWidget() {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(252, 124, 95, 1),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Row(children: [
          const Icon(
            Icons.warning,
            color: Colors.white,
            size: 30,
          ),
          const Padding(padding: EdgeInsets.only(left: 15)),
          SizedBox(
              width: SizeConfig(context).screenWidth * 0.5,
              child: Text(
                'Your server max upload size = 128M You can`t upload files larger than 128M - To upload larger files, contact your hosting provider',
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ))
        ]),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Uploads Directory', 30, 1, 'The path of uploads local directory'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Uploads Prefix', 30, 1,
          'Add a prefix to the uploaded files (No spaces or special characters only like mysite or my_site)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Uploads CDN Endpoint', 30, 1, 'Your CDN URL like AWS CloudFront'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fphoto_upload.svg?alt=media&token=4276ce30-9128-40b1-82be-14cb6185d342',
          'Photo Upload',
          'Enable photo upload to share & upload photos to the site'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          '', 'Photo Upload in Comments', 'Enable photo upload in comments'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          '', 'Photo Upload in Chat', 'Enable photo upload in chat'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect('', 'Photo Upload in News and Forums',
          'Enable photo upload in articles and forums threads'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Max Photo Size', 30, 1,
          'The Maximum size of uploaded photo in posts in kilobytes (1M = 1024KB)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      moduleDropDown('Photo Quality', photoQualityItems),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fcover_photo.svg?alt=media&token=83d324bc-c833-4cb8-bc7b-e08cfbaf11ed',
          'Cover Photo Resolution Limit',
          'Enable cover photo limit (Minimum width 1108px & Minimum height 360px)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Max Cover Photo Size', 30, 1,
          'The Maximum size of cover photo in kilobytes (1 M = 1024 KB)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Max Profile Photo Size', 30, 1,
          'The Maximum size of profile photo in kilobytes (1 M = 1024 KB)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fwatermark.svg?alt=media&token=93a32704-ad76-44cc-94d1-246728e9ab12',
          'Watermark Images',
          'Enable it to add watermark icon to all uploaded photos (except: profile pictures and cover images)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Watermark Icon',
            style: TextStyle(color: fontColor, fontSize: 13),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    color: const Color.fromRGBO(240, 240, 240, 1),
                    width: 100,
                    height: 100,
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 70, left: 70),
                      child: const Icon(Icons.photo_camera))
                ],
              )
            ],
          )
        ],
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Watermark Position', 30, 1,
          'Select the position (the anchor point) of your watermark icon'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Watermark Opacity', 30, 1,
          'The opacity level of the watermark icon (value between 0 - 1)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Watermark X Offset', 30, 1, 'Horizontal offset in pixels'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Watermark Y Offset', 30, 1, 'Vertical offset in pixels'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fadult.svg?alt=media&token=bac7d628-d331-4d25-8a37-a0e72c08cb6e',
          'Adult Images Detection',
          'Enable it to detect the adult images and system will blur or delete them'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Row(
        children: [
          Text(
            'Adult Images Action',
            style: TextStyle(color: fontColor, fontSize: 13),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
          ),
          Transform.scale(
              scale: 0.7,
              child: Checkbox(
                fillColor: MaterialStateProperty.all<Color>(Colors.blue),
                checkColor: Colors.white,
                activeColor: const Color.fromRGBO(0, 123, 255, 1),
                value: check1,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0))), // Rounded Checkbox
                onChanged: (value) {
                  setState(() {
                    check1 = check1 ? false : true;
                  });
                },
              )),
          Text(
            'Blur',
            style: TextStyle(color: fontColor, fontSize: 13),
          ),
          Transform.scale(
              scale: 0.7,
              child: Checkbox(
                fillColor: MaterialStateProperty.all<Color>(Colors.blue),
                checkColor: Colors.white,
                activeColor: const Color.fromRGBO(0, 123, 255, 1),
                value: check1,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0))), // Rounded Checkbox
                onChanged: (value) {
                  setState(() {
                    check1 = check1 ? false : true;
                  });
                },
              )),
          Text(
            'Delete',
            style: TextStyle(color: fontColor, fontSize: 13),
          ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Google Vision API Key', 30, 1, 'Your Cloud Vision API Key'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fvideo_upload.svg?alt=media&token=80f53143-ec9e-482e-acd2-47512e7bee2e',
          'Video Upload',
          'Enable video upload to share & upload videos to the site'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Max video size', 30, 1,
          'The Maximum size of uploaded video in posts in kilobytes (1M = 1024KB)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Video extensions', 30, 1,
          'Allowed video extensions (separated with comma)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Faudio_upload.svg?alt=media&token=ecf75ba4-f46a-4bd1-8ec9-a8995bb3a5ce',
          'Audio Upload',
          'Enable audio upload to share & upload sounds to the site'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Max audio size', 30, 1,
          'The Maximum size of uploaded audio in posts in kilobytes (1M = 1024KB)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Audio extensions', 30, 1,
          'Allowed audio extensions (separated with comma )'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Ffile_upload.svg?alt=media&token=81307412-cacf-496a-9fb3-fabe61e8593b',
          'File Upload',
          'Enable file upload to share & upload files to the site'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('Max file size', 30, 1,
          'The Maximum size of uploaded file in posts in kilobytes (1M = 1024KB)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput('File extensions', 30, 1,
          'Allowed file extensions (separated with comma `,)'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 20),
      ),
      Container(
          alignment: Alignment.topRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(245, 54, 92, 1),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0)),
              minimumSize: const Size(200, 50),
              maximumSize: const Size(200, 50),
            ),
            onPressed: () {
              () => {};
            },
            child: const Text('Test Connection (Vision API)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold)),
          )),
      footer()
    ]);
  }

  Widget selectAndText(content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
            scale: 0.7,
            child: Checkbox(
              fillColor: MaterialStateProperty.all<Color>(Colors.blue),
              checkColor: Colors.white,
              activeColor: const Color.fromRGBO(0, 123, 255, 1),
              value: check1,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0))), // Rounded Checkbox
              onChanged: (value) {
                setState(() {
                  check1 = check1 ? false : true;
                });
              },
            )),
        SizedBox(
          width: SizeConfig(context).screenWidth * 0.25,
          child: Text(
            content,
            style: const TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }

  Widget amazonWidget() {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
        decoration: const BoxDecoration(
            color: Color.fromRGBO(252, 124, 95, 1),
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Row(children: [
          const Icon(
            FontAwesomeIcons.amazon,
            color: Colors.white,
            size: 30,
          ),
          const Padding(padding: EdgeInsets.only(left: 15)),
          SizedBox(
              width: SizeConfig(context).screenWidth * 0.5,
              child: Text(
                "Amazon S3 Storage Before enabling Amazon S3, make sure you upload the whole 'uploads' folder to your bucket.Before disabling Amazon S3, make sure you download the whole 'uploads' folder to your server.",
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ))
        ]),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      pictureAndSelect(
          'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Famazon.svg?alt=media&token=537392f0-28b2-426a-81d9-fa54d9ac060e',
          'Amazon S3 Storage',
          'Enable Amazon S3 storage (Note: Enable this will disable all other options)'),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      titleAndsubtitleInput('Bucket Name', 30, 1, 'Your Amazon S3 bucket name'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Bucket Region', 30, 1, 'Your Amazon S3 bucket region'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Access Key ID', 30, 1, 'Your Amazon S3 Access Key ID'),
      const Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      titleAndsubtitleInput(
          'Access Key Secret', 30, 1, 'Your Amazon S3 Access Key Secret'),
      const Padding(
        padding: EdgeInsets.only(top: 50),
      ),
      Container(
        height: 1,
        color: const Color.fromRGBO(240, 240, 240, 1),
      ),
      uploadFotter()
    ]);
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

  Widget titleAndsubtitleDropdown(title, List<Map> dropDownItems, subtitle) {
    return Row(
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
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    width: 400,
                    height: 30,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 250, 250),
                        border: Border.all(color: Colors.grey)),
                    child: DropdownButton(
                      value: dropDownItems[0]['value'],
                      items: dropDownItems
                          .map(
                            (e) => DropdownMenuItem(
                                value: e['value'],
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    e['title'],
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                )),
                          )
                          .toList(),
                      onChanged: (value) {
                        //get value when changed
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
                    )),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ]),
            ))
      ],
    );
  }

  Widget titleAndsubtitleInput(title, height, line, subtitle) {
    return Row(
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
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  width: 400,
                  height: height,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 250, 250),
                      border: Border.all(color: Colors.grey)),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: line,
                    onChanged: (value) async {},
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
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ]),
            ))
      ],
    );
  }

  Widget pictureAndSelect(svgSource, title, content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        svgSource == ''
            ? Container(
                width: 40,
              )
            : SvgPicture.network(
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

  Widget moduleDropDown(title, List<Map> dropDownItems) {
    return Row(
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
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
              ]),
            ))
      ],
    );
  }
}
