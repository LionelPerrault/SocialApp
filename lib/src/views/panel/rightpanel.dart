import 'package:flutter/material.dart';

import '../box/users_suggestion_box.dart';
import '../box/pages_suggestion_box.dart';
import '../box/groups_suggestion_box.dart';
import '../box/events_suggestion_box.dart';

// ignore: must_be_immutable
class RightPanel extends StatelessWidget {
  RightPanel({super.key, required this.routerChange});
  Function routerChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.only(top: 0.0),
        ),
        ShnatterUserSuggest(routerChange: routerChange),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        ShnatterPageSuggest(routerChange: routerChange),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        ShnatterGroupSuggest(routerChange: routerChange),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        ShnatterEventSuggest(routerChange: routerChange),
        const Padding(padding: EdgeInsets.only(top: 10.0)),
      ]),
    );
  }
}
