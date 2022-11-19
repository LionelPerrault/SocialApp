
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_footer.dart';
import 'package:shnatter/src/views/admin/admin_panel/widget/setting_header.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

// ignore: must_be_immutable
class AdminSettingsSystem extends StatefulWidget {
  AdminSettingsSystem(
      {super.key});
  
  @override
  State createState() => AdminSettingsSystemState();
}
class AdminSettingsSystemState extends mvc.StateMVC<AdminSettingsSystem>{
  @override
  void initState(){
    super.initState();
    headerTab = [
      {'icon':Icons.safety_check,'title':'General','onClick':(value) {tabTitle = value;setState(() { });}},
      {'icon':Icons.map,'title':'SEO','onClick':(value) {tabTitle = value;setState(() { });}},
      {'icon':Icons.mode,'title':'Modules','onClick':(value) {tabTitle = value;setState(() { });}}
  ] ;
  }
  bool check1 = false;
  Color fontColor = const Color.fromRGBO(82, 95, 127,1);
  double fontSize = 14;
  String tabTitle = 'General';
  late var headerTab;
  List<Map> dateTimeArr = [
    {'value': 'd/m/y','title':'d/m/Y H:i (Example: 30/05/2019 17:30)'},
    {'value': 'm/d/y','title':'m/d/Y H:i (Example: 05/30/2019 17:30)'}
  ];
  List<Map> distanceArr = [
    {'value': 'Kilometer','title':'Kilometer'},
    {'value': 'Mile','title':'Mile'},
  ];
  List<Map> currency = [
    {'value':'Australia Dollar','title':'Australia Dollar'},
    {'value':'Brazil Real (BRL)','title':'Brazil Real (BRL)'},
    {'value':'Canada Dollar (CAD)','title':'Canada Dollar (CAD)'},
    {'value':'Czech Republic Koruna (CZK)','title':'Czech Republic Koruna (CZK)'},
    {'value':'Denmark Krone (DKK)','title':'Denmark Krone (DKK)'},
    {'value':'Euro (EUR)','title':'Euro (EUR)'},
    {'value':'Hong Kong Dollar (HKD)','title':'Hong Kong Dollar (HKD)'},
    {'value':'Hungary Forint (HUF)','title':'Hungary Forint (HUF)'},
    {'value':'Israel Shekel (ILS)','title':'Israel Shekel (ILS)'},
    {'value':'Japan Yen (JPY)','title':'Japan Yen (JPY)'},
    {'value':'Malaysia Ringgit (MYR)','title':'Malaysia Ringgit (MYR)'},
    {'value':'Mexico Peso (MXN)','title':'Mexico Peso (MXN)'},
    {'value':'Norway Krone (NOK)','title':'Norway Krone (NOK)'},
    {'value':'New Zealand Dollar (NZD)','title':'New Zealand Dollar (NZD)'},
    {'value':'Philippines Peso (PHP)','title':'Philippines Peso (PHP)'},
    {'value':'Poland Zloty (PLN)','title':'Poland Zloty (PLN)'},
    {'value':'United Kingdom Pound (GBP)','title':'United Kingdom Pound (GBP)'},
    {'value':'Russia Ruble (RUB)','title':'Russia Ruble (RUB)'},
    {'value':'Singapore Dollar (SGD)','title':'Singapore Dollar (SGD)'},
    {'value':'Sweden Krona (SEK)','title':'Sweden Krona (SEK)'},
    {'value':'Switzerland Franc (CHF)','title':'Switzerland Franc (CHF)'},
    {'value':'Thailand Baht (THB)','title':'Thailand Baht (THB)'},
    {'value':'Turkey Lira (TRY)','title':'Turkey Lira (TRY)'},
    {'value':'United States Dollar (USD)','title':'United States Dollar (USD)'},
    {'value':'Shnatter token (SHN)','title':'Shnatter token (SHN)'},
  ];
  List<Map> directionCurrency = [
    {'value':'left','title':'left'},
    {'value':'right','title':'right'},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right:40),
      child: Column(
        children: [
          AdminSettingHeader(icon: const Icon(Icons.settings), pagename: 'Settings › Analytics', button: const {'flag': false},headerTab: headerTab,),
          Container(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
            child: 
            tabTitle == 'General' ?
              generalWidget() :
            tabTitle == 'SEO' ?
              seoWidget() :
              modulesWidget()
          ) 
          
        ],
      ),
    );
  }
  Widget seoWidget(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fwebsite.svg?alt=media&token=d55ae5de-546a-453f-8590-ddb48b77dccf',width: 40,),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Website Public',style: TextStyle(
                    color: fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                  const Padding(padding: EdgeInsets.only(left: 20)),
                  const Text('Make the website public to allow non logged users to view website content',
                    style: TextStyle(
                      fontSize: 13
                    ),
                  )
                ],
              ),
              ),
              
              const Flexible(fit: FlexFit.tight,child: SizedBox()),
              SizedBox(
                height: 20,
                child: Transform.scale(
                  scaleX: 1,
                  scaleY: 1,
                  child: CupertinoSwitch(
                    thumbColor: Colors.white,
                    activeColor: Colors.black,
                    value: true,
                    onChanged: (value) {
                    },
                  ),
                ),
              ),
            ],
          ),
              const Padding(padding: EdgeInsets.only(top: 30),),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fnews.svg?alt=media&token=e9f948f7-edbf-4b5e-9781-3bc6b6a27342',width: 40,),
              Flexible(
                flex: 4,
                child: 
              Container(
                padding: EdgeInsets.only(left: 10,right: 30),
                width: SizeConfig(context).screenWidth*0.5,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Newsfeed Public',style: TextStyle(
                    color: fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                      
                    Text(
                      overflow: TextOverflow.clip,
                      'Make the newsfeed available for visitors in landing pageEnable this will make your website public and list only public posts',
                    style: TextStyle(
                      fontSize: 13
                    )),
                  
                ],
              ),
              )),
              
              const Flexible(fit: FlexFit.tight,child: SizedBox()),
              SizedBox(
                height: 20,
                child: Transform.scale(
                  scaleX: 1,
                  scaleY: 1,
                  child: CupertinoSwitch(
                    thumbColor: Colors.white,
                    activeColor: Colors.black,
                    value: true,
                    onChanged: (value) {
                    },
                  ),
                ),
              ),
            ],
          ),
              const Padding(padding: EdgeInsets.only(top: 30),),

          Row(
            children: [
              SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fdirectory.svg?alt=media&token=0fb7c552-4372-483a-8467-81f4c155993a',width: 40,),
              Flexible(
                flex: 4,
                child:
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Directory',style: TextStyle(
                    color: fontColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
                  const Padding(padding: EdgeInsets.only(left: 20)),
                  const Text('Enable the directory for better SEO resultsMake the website public to allow non logged users to view website content',
                    style: TextStyle(
                      fontSize: 13
                    ),
                  )
                ],
              ),
              )),
              
              const Flexible(fit: FlexFit.tight,child: SizedBox()),
              SizedBox(
                height: 20,
                child: Transform.scale(
                  scaleX: 1,
                  scaleY: 1,
                  child: CupertinoSwitch(
                    thumbColor: Colors.white,
                    activeColor: Colors.black,
                    value: true,
                    onChanged: (value) {
                    },
                  ),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Website Title', 30,1,'Title of your website'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Website Description', 100,7,'Description of your website'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Website Keywords', 100,7,'Example: social, sngine, social site'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Directory Description', 100,7,'Description of your Directory'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('News Description', 100,1,'Description of your news module'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Marketplace Description', 100,1,'Description of your marketplace module'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Funding Description', 100,1,'Description of your funding module'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Offers Description', 100,1,'Description of your offer module'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Jobs Description', 100,1,'Description of your jobs module'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Forums Description', 100,1,'Description of your forums module'),
          const Padding(padding: EdgeInsets.only(top: 30),),
          systemInput('Movies Description', 100,1,'Description of your movies module'),
          const Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                height: 80,
                decoration: const BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1),
                  border: Border(top:BorderSide(width: 0.5,color: Colors.grey))
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 15),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(2.0)),
                      minimumSize: const Size(150, 50),
                      maximumSize: const Size(150, 50),
                    ),
                    onPressed: () {
                      () => {};
                    },
                    child:
                        const Text('Save Changes',
                            style: TextStyle(
                                color: Color.fromARGB(
                                    255, 33, 37, 41),
                                fontSize: 11.0,
                                fontWeight:
                                    FontWeight.bold)),
                    )),
        ],
      ),
    );
  }
  Widget modulesWidget(){
    return Container(

    );
  }
  Widget generalWidget(){
    return Container(
            child: 
            Column(
              children: [
                  Row(
                children: [
                  SvgPicture.network('https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fadmin%2Fsettings%2Fglobal.svg?alt=media&token=a643b225-ed3a-4d0a-9bfd-8b70518f6424',width: 40,),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Website Live',style: TextStyle(
                          color: fontColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),),
                        const Padding(padding: EdgeInsets.only(top: 5)),
                        const Text('Turn the entire website On and Off',
                          style: TextStyle(
                            fontSize: 14
                          ),)
                      ],
                    ),
                  ),
                  const Flexible(fit: FlexFit.tight,child: SizedBox(),),
                  SizedBox(
                    height: 20,
                    child: Transform.scale(
                      scaleX: 1,
                      scaleY: 1,
                      child: CupertinoSwitch(
                        thumbColor: Colors.white,
                        activeColor: Colors.black,
                        value: true,
                        onChanged: (value) {
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 30),),
              systemInput('Shutdown Message', 150,7,'The text that is presented when the site is closed'),
              const Padding(padding: EdgeInsets.only(top: 30)),
              systemInput('System Email', 30, 1, 'The contact email that all messages send to'),
              const Padding(padding: EdgeInsets.only(top: 30)),
              systemDropDown('System Datetime Format', dateTimeArr, 'Select the datetime format of the datetime picker'),
              const Padding(padding: EdgeInsets.only(top: 30)),
              systemDropDown('System Distance Unit',distanceArr,'Select the distance measure unit of your website'),
              const Padding(padding: EdgeInsets.only(top: 30)),
              systemDropDown('System Currency',currency,'You can add, edit or delete currencies from Currencies'),
              const Padding(padding: EdgeInsets.only(top: 30)),
              systemDropDown('System Currency Direction',directionCurrency,'Where to add the currency symbol relative to the money value'),
              const Padding(padding: EdgeInsets.only(top: 30)),
              Container(
                height: 80,
                decoration: const BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1),
                  border: Border(top:BorderSide(width: 0.5,color: Colors.grey))
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 15),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(2.0)),
                      minimumSize: const Size(150, 50),
                      maximumSize: const Size(150, 50),
                    ),
                    onPressed: () {
                      () => {};
                    },
                    child:
                        const Text('Save Changes',
                            style: TextStyle(
                                color: Color.fromARGB(
                                    255, 33, 37, 41),
                                fontSize: 11.0,
                                fontWeight:
                                    FontWeight.bold)),
                    )),
              ],
            )
            
          );
  }
  Widget systemDropDown(title,List<Map> dropDownItems,subtitle){
    return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style: TextStyle(
                  color: fontColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold
                ),  
              ),
            const Flexible(fit:FlexFit.tight,child: SizedBox()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                  width: SizeConfig(context).screenWidth * 0.5,
                  height: 30,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: DropdownButton(
                                  value: dropDownItems[0]['value'],
                                  items: dropDownItems.map((e)=>
                                    DropdownMenuItem(
                                      value: e['value'],
                                      child:Padding
                                    (padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                          e['title'],
                                          style: const TextStyle(fontSize: 13,
                                            color: Colors.grey
                                          ),
                                        ),)
                                        
                                    ),
                                  ).toList(),
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
                                )
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                Text(subtitle,style: TextStyle(
                  fontSize: fontSize
                ),)
              ],
            )
            ],
          );
  }
  Widget systemInput(title,height,line,subtitle){
    return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                style: TextStyle(
                  color: fontColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold
                ),  
              ),
            const Flexible(fit:FlexFit.tight,child: SizedBox()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                  width: SizeConfig(context).screenWidth * 0.5,
                  height: height,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 250, 250, 250),
                      border:
                          Border.all(color: Colors.grey)),
                  child: TextFormField(
                        minLines: 1,
                        maxLines: line,
                        onChanged: (value) async {
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
                const Padding(padding: EdgeInsets.only(top: 5)),
                Text(subtitle,style: TextStyle(
                  fontSize: fontSize
                ),)
              ],
            )
            ],
          );
  }
}
