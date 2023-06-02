import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/colors.dart';

class SendTokenWdiget extends StatefulWidget {
  SendTokenWdiget({Key? key})
      : con = UserController(),
        super(key: key);
  final UserController con;
  @override
  State createState() => SendTokenWdigetState();
}

class SendTokenWdigetState extends mvc.StateMVC<SendTokenWdiget>
    with TickerProviderStateMixin {
  Map sendTokenData = {};
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  late TabController _tabController;
  late UserController con;

  @override
  void initState() {
    add(widget.con);
    super.initState();
    con = controller as UserController;
    _tabController = TabController(
      vsync: this,
      length: 2,
      initialIndex: _currentTabIndex,
    );
    _tabController.animateTo(_currentTabIndex);
  }

  int _currentTabIndex = 0;
  bool isSending = false;
  String code = '';

  sendToken() async {
    isSending = true;
    setState(() {});
    String address = sendTokenData['address'] ?? '';
    String amount = sendTokenData['amount'] ?? '';
    String message = sendTokenData['message'] ?? '';

    if (address == '' || amount == '') {
      Helper.showToast('Please fill all field');
      isSending = false;
      setState(() {});
      return;
    }
    List paymails = [];
    if (address.contains(',') || address.length < 21) {
      List addresses = address.split(',');
      addresses.forEach((e) {
        e = e.replaceAll('@', '');
        if (int.tryParse(e) != null) {
          paymails.add('$e@shnatter.app');
        } else {
          if (Helper.userUidToInfo[Helper.userNameToUid[e]] == null) {
            Helper.showToast('User does not exist');
          } else {
            paymails
                .add(Helper.userUidToInfo[Helper.userNameToUid[e]]['paymail']);
          }
        }
      });
      await con.payMultiUserShnToken(paymails, amount, message).then((value) {
        if (value) {
          Helper.showToast('Successfully paid');
        }
      });
    } else {
      var mUserData = await Helper.userCollection
          .where('invitecode', isEqualTo: address.replaceAll('@', ''))
          .get();
      for (var i = 0; i < mUserData.docs.length; i++) {
        paymails.add(mUserData.docs[i].data()['paymail']);
      }
      if (paymails.isEmpty) {
        Helper.showToast('There is not user that invited using this code');
      }
      await con.payMultiUserShnToken(paymails, amount, message);
    }
    isSending = false;
    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              FontAwesomeIcons.angleLeft,
              size: 30,
            ),
          ),
          backgroundColor: headerColor,
          bottom: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                _currentTabIndex = index;
              });
            },
            tabs: const [
              Tab(text: 'Scan'),
              Tab(text: 'Send'),
            ],
          ),
        ),
        body: Container(
            alignment: Alignment.topCenter,
            child: _currentTabIndex == 0
                ? QrCodeScanner(context)
                : tokenPay(context)));
  }

  Widget QrCodeScanner(BuildContext context) {
    return Stack(children: [
      MobileScanner(onDetect: (barcode) {
        if (barcode.barcodes.first.rawValue == null) {
          debugPrint('Failed to scan Barcode');
        } else {
          code = barcode.barcodes.first.rawValue
              .toString()
              .replaceAll("Receive at:", "");

          if (!code.contains('receiveFromAdmin')) {
            // con.payMail = code;
            // payMailController.text = '@${code.replaceAll(Helper.replace, '')}';
            // setState(() {
            //   isScanned = false;
            //   _currentTabIndex = 1;
            // });
          }
        }
      }),
      // const ScanRect()
    ]);
  }

  Widget tokenPay(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(25),
                  width: 1000,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 14.0,
                        spreadRadius: 4,
                        offset: Offset(
                          1,
                          3,
                        ),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 700,
                              child: titleAndsubtitleInput(
                                  'Address',
                                  'You can insert @‌Username, @‌Paymail or @Invited Code',
                                  50,
                                  1, (String value) {
                                value = value.replaceAll(
                                    RegExp('[^A-Za-z0-9,@]'), '');
                                if (value[0] != '@') {
                                  value = '@$value';
                                }
                                if (value[value.length - 2] == ',') {
                                  value =
                                      '${value.substring(0, value.length - 1)}@${value[value.length - 1]}';
                                }
                                sendTokenData['address'] = value;
                                addressController.text = value;
                                addressController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: addressController.text.length));
                                setState(() {});
                              }, controller: addressController),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 700,
                              child: titleAndsubtitleInput('Amount', '', 50, 1,
                                  (value) {
                                if (int.tryParse(value) == null) {
                                  value = sendTokenData['amount'] ??
                                      'Please insert only number';
                                }
                                sendTokenData['amount'] = value;
                                amountController.text = value;
                                amountController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: amountController.text.length));
                                setState(() {});
                              }, controller: amountController),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 700,
                              child: titleAndsubtitleInput(
                                  'Message', '', 100, 4, (value) {
                                sendTokenData['message'] = value;
                                messageController.text = value;
                                messageController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: messageController.text.length));
                                setState(() {});
                              }, controller: messageController),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(3),
                                  backgroundColor: Colors.blue,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0)),
                                  minimumSize: const Size(140, 50),
                                  maximumSize: const Size(140, 50),
                                ),
                                onPressed: () {
                                  if (!isSending) sendToken();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: isSending
                                      ? const [
                                          SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: CircularProgressIndicator(
                                                color: Colors.grey),
                                          )
                                        ]
                                      : const [
                                          Icon(Icons.send),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('Send Token',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget titleAndsubtitleInput(
      title, String hintText, double height, line, insertValue,
      {controller}) {
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
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 85, 95, 127)),
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: 400,
                  height: height,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLines: line,
                        minLines: line,
                        controller: controller,
                        onChanged: (value) {
                          insertValue(value);
                        },
                        decoration: InputDecoration(
                          suffix: Container(
                            width: 30,
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Helper.showToast(hintText);
                              },
                              child: const Icon(
                                Icons.question_mark,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.only(top: 10, left: 10),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
