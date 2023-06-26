// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;

class LiveStreaming extends StatefulWidget {
  LiveStreaming({Key? key, required this.routerChange}) : super(key: key);
  Function routerChange;

  @override
  State createState() => LiveStreamingState();
}

class LiveStreamingState extends mvc.StateMVC<LiveStreaming>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Live Streaming');
  }
}
