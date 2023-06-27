import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gMap;
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';
import 'package:shnatter/src/managers/GeolocationManager.dart';
//import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';

// ignore: must_be_immutable
class UserExplore extends StatefulWidget {
  UserExplore({Key? key, required this.routerChange})
      : con = UserController(),
        super(key: key);
  final UserController con;
  Function routerChange;

  @override
  State createState() => UserExploreState();
}

class UserExploreState extends mvc.StateMVC<UserExplore>
    with TickerProviderStateMixin {
  late UserController con;
  int _currentTabIndex = 0;
  bool isShowChoosePane = false;
  bool isSelectArea = false;
  bool isBackHovered = false;
  double zoomv = 19;
  GeoFlutterFire geo = GeoFlutterFire();
  late StreamSubscription subscription;
  gMap.LatLng searchPoint = const gMap.LatLng(0, 0);
  gMap.LatLng choosePoint = const gMap.LatLng(0, 0);

  String _currentAddress = "...";
  //Position? _currentPosition;
  late gMap.GoogleMapController mapController;
  bool isInitialized = false;
  Map<gMap.MarkerId, gMap.Marker> markers =
      <gMap.MarkerId, gMap.Marker>{}; // CLASS MEMBER, MAP OF MARKS
  List<Map> clientData = [];
  static const gMap.CameraPosition _kLake = gMap.CameraPosition(
      bearing: 192.8334901395799,
      target: gMap.LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  double _currentSliderValue = 10;

  @override
  void initState() {
    //add(widget.con);
    updateGeoInfos();
    super.initState();
  }

  Widget listData() {
    return Padding(
        padding: const EdgeInsets.only(top: 150),
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(
            thickness: 0.5,
            height: 1,
          ),
          itemCount: clientData.length,
          itemBuilder: (BuildContext context, int index) {
            var data = clientData[index];
            return GestureDetector(
              onTap: () {
                ProfileController().updateProfile(data["userName"]);
                widget.routerChange({
                  'router': RouteNames.profile,
                  'subRouter': data['userName']
                });
              },
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                leading: data['avatar'] == ''
                    ? CircleAvatar(
                        radius: 17, child: SvgPicture.network(Helper.avatar))
                    : CircleAvatar(
                        radius: 17,
                        backgroundImage: NetworkImage(data['avatar'])),
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 11),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${data['firstName']} ${data['lastName']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => {
            searchPoint = gMap.LatLng(position.latitude, position.longitude),
            choosePoint = gMap.LatLng(position.latitude, position.longitude),
            //searchPoint = const LatLng(47.3707688, 8.5110079)
            //searchPoint = LatLng(48.84311, 2.345817)
          });
      Helper.updateGeoPoint(searchPoint.latitude, searchPoint.longitude);
      _startQuery();
      _getAddressFromLatLng(searchPoint);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void updateGeoInfos() {
    searchPoint = GeolocationManager.searchPoint;
    choosePoint = GeolocationManager.choosePoint;

    if (isInitialized) {
      mapController.moveCamera(gMap.CameraUpdate.newCameraPosition(
          // on below line we have given positions of Location 5
          gMap.CameraPosition(
        target: gMap.LatLng(searchPoint.latitude, searchPoint.longitude),
        zoom: zoomv.toDouble(),
      )));
    }

    _startQuery();
    _getAddressFromLatLng(searchPoint);
  }

  Future<void> _getAddressFromLatLng(gMap.LatLng position) async {
    if (!kIsWeb) {
      try {
        await placemarkFromCoordinates(position.latitude, position.longitude)
            .then((List<Placemark> placemarks) {
          Placemark place = placemarks[0];
          //
          setState(() {
            _currentAddress =
                '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
          });
        }).catchError((e) {
          _currentAddress = '${position.latitude}, ${position.longitude} ';

          debugPrint(e);
        });
      } catch (e) {
        _currentAddress = '${position.latitude}, ${position.longitude} ';
      }
    } else {
      _currentAddress = '${position.latitude}, ${position.longitude} ';
    }
  }

  _startQuery() async {
    // Make a referece to firestore
    var ref = FirebaseFirestore.instance.collection('user');
    GeoFirePoint center = geo.point(
        latitude: searchPoint.latitude, longitude: searchPoint.longitude);

    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: ref)
        .within(
            center: center,
            radius: _currentSliderValue,
            field: 'position',
            strictMode: true);

    stream.listen((List<DocumentSnapshot> documentList) {
      _updateMarkers(documentList);
    });
  }

  @override
  dispose() {
    //subscription.cancel();
    super.dispose();
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    // add my position
    markers = {};
    var marker = gMap.Marker(
      markerId: const gMap.MarkerId("it's my position"),
      position: gMap.LatLng(searchPoint.latitude, searchPoint.longitude),
      icon: gMap.BitmapDescriptor.defaultMarkerWithHue(
          gMap.BitmapDescriptor.hueBlue),
      infoWindow: const gMap.InfoWindow(title: 'Magic Marker', snippet: '*'),
      onTap: () {},
    );
    markers[marker.markerId] = marker;
    clientData = [];
    for (var document in documentList) {
      Map data = document.data() as Map;
      if (data['nearbyOptOut'] == false) {
        clientData.add({...data, 'id': document.id});
        GeoPoint pos = data['position']['geopoint'] as GeoPoint;

        var marker = gMap.Marker(
            markerId: gMap.MarkerId(document.id),
            position: gMap.LatLng(pos.latitude, pos.longitude),
            icon: gMap.BitmapDescriptor.defaultMarkerWithHue(
                gMap.BitmapDescriptor.hueRed),
            infoWindow: gMap.InfoWindow(
                onTap: () async {
                  ProfileController().updateProfile(data["userName"]);
                  widget.routerChange({
                    'router': RouteNames.profile,
                    'subRouter': data['userName']
                  });
                },
                title: '${data['firstName']} ${data['lastName']}',
                snippet: ''),
            onTap: () async {});
        markers[marker.markerId] = marker;
      }
    }
    setState(() {});
  }

  Widget boardPane() {
    return Container(
      //width: SizeConfig(context).screenWidth - 100,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 219, 224, 223),
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: Offset(0.0, 0.0),
          )
        ],
      ),
      child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig(context).screenWidth - 120,
                    height: 50,
                    child: Text(
                      _currentAddress,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      maxLines: 20,
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Colors.lightBlue),
                    ),
                  ),
                  Text("within $_currentSliderValue km",
                      style: const TextStyle(color: Colors.lightBlue))
                ],
              ),
              const Icon(Icons.arrow_circle_down)
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: SizeConfig(context).screenHeight - 120,
        child: Stack(children: [
          _currentTabIndex == 1 ? googleMap() : listData(),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
            child: InkWell(
              child: boardPane(),
              onTap: () {
                setState(() {
                  isShowChoosePane = true;
                });
              },
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 10, left: 10),
          //   child: InkWell(
          //       onTap: () =>
          //           {print("this is log clicked"), Navigator.of(context).pop()},
          //       onHover: (value) => {
          //             setState(() {
          //               isBackHovered = value;
          //             }),
          //             print("onHover")
          //           },
          //       onFocusChange: (value) => {
          //             setState(() {
          //               isBackHovered = value;
          //             }),
          //             print("onHover")
          //           },
          //       child: Container(
          //           width: 60,
          //           height: 60,
          //           child: Center(child: Icon(Icons.arrow_back_ios)),
          //           decoration: BoxDecoration(
          //             color: isBackHovered
          //                 ? Colors.lightBlue
          //                 : Color.fromARGB(51, 33, 73, 54),
          //             borderRadius: BorderRadius.all(Radius.circular(30)),
          //           ))),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: tabPane(),
          ),
          isShowChoosePane == true ? choosePane() : Container(),
          isShowChoosePane == false && _currentTabIndex == 1
              ? chooseArea()
              : Container()
        ]),
      ),
    );
  }

  Widget choosePane() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Color.fromARGB(115, 97, 96, 96)),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Stack(
          children: [
            Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: const Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    "Choose a radius to see",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  Text("what's available",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.all(5.0),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: (() {
                    isShowChoosePane = false;
                    setState(() {});
                  }),
                  child: const Icon(Icons.close),
                )),
          ],
        ),
        Container(
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          width: double.infinity,
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("Select a distance",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Slider(
                  value: _currentSliderValue,
                  min: 10,
                  max: 5000,
                  divisions: 5000 - 10,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value.roundToDouble();
                    });
                  },
                )),
                Text("$_currentSliderValue km")
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: MyPrimaryButton(
                  color: Colors.lightBlue,
                  buttonName: "Apply",
                  onPressed: () {
                    isShowChoosePane = false;
                    _startQuery();
                    setState(() {});
                  }),
            )
          ]),
        )
      ]),
    );
  }

  Widget chooseArea() {
    var leftPaneWidth =
        SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
            ? SizeConfig.leftBarWidth
            : 0;
    return Positioned(
      bottom: 30,
      child: Container(
        margin: const EdgeInsets.only(right: 0),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width:
                  (SizeConfig(context).screenWidth - leftPaneWidth) * 0.05 + 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  minimumSize: Size(
                      (SizeConfig(context).screenWidth - leftPaneWidth) * 0.7 -
                          80,
                      50),
                ),
                onPressed: () {
                  choosePoint = searchPoint;
                  _currentAddress = "Loading...";
                  setState(() {});
                  _startQuery();
                  isSelectArea = false;
                  _getAddressFromLatLng(choosePoint);
                  setState(() {});
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Explore here",
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        )),
                  ],
                )),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.grey,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  minimumSize: const Size(50, 50),
                ),
                onPressed: () {
                  _currentAddress = "Loading...";
                  updateGeoInfos();
                  isSelectArea = false;
                  setState(() {});
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.lightBlue,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget tabPane() {
    Color dselColor = const Color.fromARGB(51, 33, 73, 54);
    Color selColor = Colors.lightBlue;
    Color selText = Colors.white;
    Color dselText = Colors.lightBlue;
    var leftPaneWidth =
        SizeConfig(context).screenWidth > SizeConfig.mediumScreenSize
            ? SizeConfig.leftBarWidth
            : 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: Container(
            height: 40,
            width: (SizeConfig(context).screenWidth - leftPaneWidth - 20) / 2,
            decoration: BoxDecoration(
              color: _currentTabIndex == 0 ? selColor : dselColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: Center(
                child: Text(
              "List",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: _currentTabIndex == 0 ? selText : dselText),
            )),
          ),
          onTap: () => {_currentTabIndex = 0, setState(() {})},
        ),
        InkWell(
            onTap: () => {_currentTabIndex = 1, setState(() {})},
            child: Container(
                width:
                    (SizeConfig(context).screenWidth - leftPaneWidth - 20) / 2,
                height: 40,
                decoration: BoxDecoration(
                  color: _currentTabIndex == 1 ? selColor : dselColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Center(
                    child: Text(
                  "Map",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: _currentTabIndex == 1 ? selText : dselText),
                ))))
      ],
    );
  }

  Widget googleMap() {
    List<double> ratiotable = [
      591657550.500000,
      295828775.300000,
      147914387.600000,
      73957193.820000,
      36978596.910000,
      18489298.450000,
      9244649.227000,
      4622324.614000,
      2311162.307000,
      1155581.153000,
      577790.576700,
      288895.288400,
      144447.644200,
      72223.822090,
      36111.911040,
      18055.955520,
      9027.977761,
      4513.988880,
      2256.994440,
      1128.497220,
    ];
    //if (!isSelectArea) {
    for (int i = 0; i < ratiotable.length; i++) {
      if (ratiotable[i] < _currentSliderValue * 10000) {
        zoomv = i - 1;
        if (zoomv < 0) zoomv = 0;
        break;
      }
    }

    Set<gMap.Circle> circles = {};
    circles = {
      gMap.Circle(
        circleId: const gMap.CircleId("current"),
        center: gMap.LatLng(searchPoint.latitude, searchPoint.longitude),
        strokeWidth: 2,
        radius: _currentSliderValue * 100,
      )
    };
    return gMap.GoogleMap(
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      mapType: gMap.MapType.normal,
      initialCameraPosition: searchPoint != null
          ? gMap.CameraPosition(
              target: gMap.LatLng(searchPoint.latitude, searchPoint.longitude),
              zoom: zoomv.toDouble(),
            )
          : _kLake,
      markers: Set<gMap.Marker>.of(markers.values),
      circles: circles,
      onCameraMove: (position) async => {
        //if (isSelectArea)
        //  {
        zoomv = await mapController.getZoomLevel(),
        setState(() {
          searchPoint =
              gMap.LatLng(position.target.latitude, position.target.longitude);
        })
        //  }
      },
      onMapCreated: (gMap.GoogleMapController controller) {
        mapController = controller;
        isInitialized = true;
        var marker = gMap.Marker(
          markerId: const gMap.MarkerId("it's my position"),
          position: gMap.LatLng(searchPoint.latitude, searchPoint.longitude),
          icon: gMap.BitmapDescriptor.defaultMarkerWithHue(
              gMap.BitmapDescriptor.hueBlue),
          infoWindow: const gMap.InfoWindow(title: 'Me', snippet: '*'),
          onTap: () {
            //
          },
        );
        setState(() {
          // adding a new marker to map
          markers[marker.markerId] = marker;
        });
      },
    );
  }
}
