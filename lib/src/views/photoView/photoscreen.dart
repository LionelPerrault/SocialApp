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
  var userInfo = UserManager.userInfo;
  late TransformationController _transformationController;
  double _scale = 1.0;
  double _previousScale = 1.0;
  bool canNext = true;
  @override
  void initState() {
    super.initState();
    add(widget.con);
    con = controller as PostController;
    currentIndex = widget.initialIndex;
    _transformationController = TransformationController();
  }

  void goToPreviousPhoto() {
    if (currentIndex > 0) {
      resetZoomLevel();
      setState(() {
        currentIndex--;
      });
    }
  }

  void goToNextPhoto() {
    if (currentIndex < widget.photoUrls.length - 1) {
      resetZoomLevel();
      setState(() {
        currentIndex++;
      });
    }
  }

  void resetZoomLevel() {
    _transformationController.value = Matrix4.identity();
    if (_scale == 1.0) {
      canNext = true;
    } else {
      canNext = false;
    }
    setState(() {});
  }

  void getSelectedPhoto(String docId) {
    con.getSelectedPost(docId).then((value) => {
          loading = false,
          setState(() {}),
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          if (!canNext) return;
          if (details.primaryVelocity! < 0) {
            goToNextPhoto();
          } else if (details.primaryVelocity! > 0) {
            goToPreviousPhoto();
          }
        },
        onScaleStart: (ScaleStartDetails details) {
          _previousScale = _scale;
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
          });
        },
        onScaleEnd: (ScaleEndDetails details) {
          _previousScale = _scale;
        },
        child: Stack(
          children: [
            Transform.scale(
              scale: _scale,
              child: Container(
                color: Colors.black,
                width: SizeConfig(context).screenWidth,
                height: SizeConfig(context).screenHeight,
                alignment: Alignment.center,
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: const EdgeInsets.all(20),
                      onInteractionEnd: (_) {
                        //  _transformationController.value = Matrix4.identity();
                      },
                      child: Container(
                        width: SizeConfig(context).screenWidth,
                        height: SizeConfig(context).screenHeight,
                        child: Image.network(widget.photoUrls[currentIndex]),
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
        ),
      ),
    );
  }
}
