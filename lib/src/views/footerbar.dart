import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shnatter/src/utils/size_config.dart';

var language = [
  {
    'langText': 'English',
    'png': 'https://test-file.shnatter.com/uploads/flags/en_us.png'
  },
  {
    'langText': 'Arabic',
    'png': 'https://test-file.shnatter.com/uploads/flags/ar_sa.png'
  },
  {
    'langText': 'French',
    'png': 'https://test-file.shnatter.com/uploads/flags/fr_fr.png'
  },
  {
    'langText': 'Spanish',
    'png': 'https://test-file.shnatter.com/uploads/flags/es_es.png'
  },
  {
    'langText': 'Portuguese',
    'png': 'https://test-file.shnatter.com/uploads/flags/pt_pt.png'
  },
  {
    'langText': 'Deutsch',
    'png': 'https://test-file.shnatter.com/uploads/flags/de_de.png'
  },
  {
    'langText': 'Turkish',
    'png': 'https://test-file.shnatter.com/uploads/flags/tr_tr.png'
  },
  {
    'langText': 'Dutch',
    'png': 'https://test-file.shnatter.com/uploads/flags/nl_nl.png'
  },
  {
    'langText': 'Italiano',
    'png': 'https://test-file.shnatter.com/uploads/flags/it_it.png'
  },
  {
    'langText': 'Russian',
    'png': 'https://test-file.shnatter.com/uploads/flags/ru_ru.png'
  },
  {
    'langText': 'Romaian',
    'png': 'https://test-file.shnatter.com/uploads/flags/ro_ro.png'
  },
  {
    'langText': 'Portuguese (Brazil)',
    'png': 'https://test-file.shnatter.com/uploads/flags/pt_br.png'
  },
  {
    'langText': 'Greek',
    'png': 'https://test-file.shnatter.com/uploads/flags/el_gr.png'
  },
];

class footbar extends StatefulWidget {
  footbar({Key? key}) : super(key: key);
  @override
  State createState() => footbarState();
}
class footbarState extends State<footbar>{
  var dropdownValue = 'English';
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 1),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 10)),
            text('@ 2022 Shnatter', const Color.fromRGBO(150, 150, 150, 1), 11),
            const Padding(padding: EdgeInsets.only(left: 20)),
             Container(
                width: 130,
                child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: Colors.black,
                          width: 0.1), //bordrder raiuds of dropdown button
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 7, left: 5),
                        child: DropdownButton(
                          value: dropdownValue,
                          items: language.map((items) {
                            return DropdownMenuItem(
                              value: items['langText'],
                              child: Container(child: Row(children: [
                                SizedBox(
                                  width: 20,
                                  child: Image.network(items['png']!),
                                ),
                                const Padding(padding: EdgeInsets.only(left: 15)),
                                Text(items['langText']!,style: TextStyle(color: Color.fromARGB(255, 60, 60, 60)),)
                              ],)
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            //get value when changed
                            dropdownValue = value!;
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
                        ))),
              ),
            const Flexible(fit: FlexFit.tight, child: SizedBox()),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Row(children: [
                text('About', Colors.grey, 11),
                const Padding(padding: EdgeInsets.only(left: 5)),
                text('Terms', Colors.grey, 11),
                const Padding(padding: EdgeInsets.only(left: 5)),
                text('Contact Us', Colors.grey, 11),
                const Padding(padding: EdgeInsets.only(left: 5)),
                text('Directory', Colors.grey, 11),
              ]),
            )
          ],
        ));
  }
}

class footbarM extends StatefulWidget {
  footbarM({Key? key}) : super(key: key);
  @override
  State createState() => footbarMState();
}
class footbarMState extends State<footbarM>{
  var dropdownValue = 'English';
  Widget build(BuildContext context) {
    return Container(
        height: 75,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 1),
        ),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            Row(children: [
              const Padding(padding: EdgeInsets.only(left: 10)),
              text('@ 2022 Shnatter', const Color.fromRGBO(150, 150, 150, 1), 13),
              const Padding(padding: EdgeInsets.only(left: 15)),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 120,left: 5),
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: Colors.black,
                            width: 0.1), //bordrder raiuds of dropdown button
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(top: 7, left: 10),
                          child: DropdownButton(
                            value: dropdownValue,
                            items: language.map((items) {
                              return DropdownMenuItem(
                                value: items['langText'],
                                child: Container(child: Row(children: [
                                  SizedBox(
                                    width: 20,
                                    child: Image.network(items['png']!),
                                  ),
                                  const Padding(padding: EdgeInsets.only(left: 15)),
                                  Text(items['langText']!,style: TextStyle(color: Color.fromARGB(255, 60, 60, 60)),)
                                ],)
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              //get value when changed
                              dropdownValue = value!;
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
                          ))),
                  ),
                ),
            ],),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: Row(children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
                text('About', Colors.grey, 13),
                const Padding(padding: EdgeInsets.only(left: 5)),
                text('Terms', Colors.grey, 13),
                const Padding(padding: EdgeInsets.only(left: 5)),
                text('Contact Us', Colors.grey, 13),
                const Padding(padding: EdgeInsets.only(left: 5)),
                text('Directory', Colors.grey, 13),
              ]),
            )
          ],
        ));
  }
}
Widget text(String title, Color color, double size) {
  return Text(title, style: TextStyle(color: color, fontSize: size));
}