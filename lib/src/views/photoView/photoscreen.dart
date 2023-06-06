import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PostController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';

class PhotoEachScreen extends StatefulWidget {
  final PostController con;

  final List<String> photoUrls;
  final int initialIndex;

  PhotoEachScreen(
      {Key? key, required this.photoUrls, required this.initialIndex})
      : con = PostController(),
        super(key: key);

  @override
  State createState() => PhotoEachScreenState();
}

class PhotoEachScreenState extends mvc.StateMVC<PhotoEachScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  late int currentIndex;
  late PostController con;
  late GlobalKey<PhotoViewerState> _viewerKey = GlobalKey();
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    currentIndex = widget.initialIndex;
  }

  void goToPreviousPhoto() {
    setState(() {
      currentIndex = (currentIndex - 1) % widget.photoUrls.length;
      _viewerKey.currentState?.resetViewer();
    });
  }

  void goToNextPhoto() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.photoUrls.length;
      _viewerKey.currentState?.resetViewer();
    });
  }

  void getSelectedPhoto(String docId) {
    con.getSelectedPost(docId).then((value) => {
          loading = false,
          setState(() {}),
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! < 0) {
          goToNextPhoto();
        } else if (details.primaryVelocity! > 0) {
          goToPreviousPhoto();
        }
      },
      child: PhotoViewer(
        key: _viewerKey,
        photoUrls: widget.photoUrls,
        initialIndex: widget.initialIndex,
      ),
    );
  }
}

class PhotoViewer extends StatefulWidget {
  final List<String> photoUrls;
  final int initialIndex;

  const PhotoViewer({
    Key? key,
    required this.photoUrls,
    required this.initialIndex,
  }) : super(key: key);

  @override
  PhotoViewerState createState() => PhotoViewerState();
}

class PhotoViewerState extends State<PhotoViewer> {
  late TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  void resetViewer() {
    setState(() {
      _controller = TransformationController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black,
          width: SizeConfig(context).screenWidth,
          height: SizeConfig(context).screenHeight,
          alignment: Alignment.center,
          child: Container(
            color: Colors.black,
            child: Center(
              child: FittedBox(
                fit: BoxFit.none,
                child: LimitedBox(
                  maxWidth: SizeConfig(context).screenWidth,
                  maxHeight: SizeConfig(context).screenHeight,
                  child: InteractiveViewer(
                    transformationController: _controller,
                    child: Image.network(widget.photoUrls[widget.initialIndex]),
                    minScale: 0.1,
                    maxScale: 4,
                    boundaryMargin:
                        EdgeInsets.all(SizeConfig(context).screenWidth * 2),
                    constrained: false,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
