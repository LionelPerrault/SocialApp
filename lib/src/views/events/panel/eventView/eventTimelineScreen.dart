
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/mindpost.dart';

class EventTimelineScreen extends StatefulWidget {
  Function onClick;
  EventTimelineScreen({Key? key,required this.onClick})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => EventTimelineScreenState();
}

class EventTimelineScreenState extends mvc.StateMVC<EventTimelineScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  double width = 0;
  double itemWidth = 0;
  //
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
  }
  late PostController con;
  @override
  Widget build(BuildContext context) {
    return Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(right: 10,left: 10,top: 15),
            child:SizeConfig(context).screenWidth < 800 ? 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                MindPost(),
                eventInfo()
              ]
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                MindPost(),
                const Flexible(fit: FlexFit.tight, child: SizedBox()),
                eventInfo(),
                const Padding(padding: EdgeInsets.only(left: 40))
            ]),
        );
  }

  @override
  Widget eventInfo() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(con.event['eventAbout'], style: const TextStyle(
          fontSize: 13,
        ),),
        const Divider(
          thickness: 0.4,
          color: Colors.black,
        ),
        eventInfoCell(
          icon: Icon(con.event['eventPrivacy'] == 'public' ? Icons.language
                        : con.event['eventPrivacy'] == 'security' ?  Icons.lock
                        : Icons.lock_open_rounded, color: Colors.grey,),
          text: con.event['eventPrivacy'] == 'public' ? 'Public Event'
                        : con.event['eventPrivacy'] == 'security' ?  'Security Event'
                        : 'Closed Event'
        ),
        eventInfoCell(
          icon: Icon(Icons.punch_clock),
          text: '${con.event["eventDate"]} ${con.event["eventEndDate"]}'
        ),
        eventInfoCell(
          icon: Icon(Icons.person),
          text: 'Hosted by ${con.event["eventAdmin"]["fullName"]}'
        ),
        eventInfoCell(
          icon: Icon(Icons.tag),
          text: 'B/N'
        ),
        eventInfoCell(
          icon: Icon(Icons.maps_ugc),
          text: '${con.event["eventLocation"]}'
        ),
        const Divider(
          thickness: 0.1,
          color: Colors.black,
        ),
        eventInfoCell(
          icon: Icon(Icons.event),
          text: '${con.event["eventGoing"].length} Going'
        ),
        eventInfoCell(
          icon: Icon(Icons.event),
          text: '${con.event["eventInterested"].length} Interested'
        ),
        eventInfoCell(
          icon: Icon(Icons.event),
          text: '${con.event["eventInvited"].length} Invited'
        ),
      ],),
    );
  }

  @override
  Widget eventInfoCell({icon, text}) {
    return Container(
      child: Row(children: [
        icon,
        const Padding(padding: EdgeInsets.only(left: 10)),
        Text(text, style: const TextStyle(
          fontSize: 13
        ),)
      ]),
    );
  }
}
