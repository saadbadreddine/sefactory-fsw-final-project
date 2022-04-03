import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hustle_app/utils/storage.dart';

import '../api/post_service.dart';
import '../model/post_model.dart';
import '../model/sport_model.dart';
import '../model/user_model.dart';

class Map extends StatefulWidget {
  final List<Marker> markers;
  const Map({Key? key, required this.markers}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MapState();
}

class MapState extends State<Map> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController newGoogleMapController;

  late Position currentPosition;
  var geoLocator = Geolocator();

  String? _darkMapStyle;
  String? _lightMapStyle;

  PostService postService = PostService();
  List<Post> posts = [];
  List<Marker> myMarker = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _setMapStyle();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialLocation =
        const CameraPosition(zoom: 8, target: LatLng(33.8547, 35.8623));

    return GoogleMap(
      markers: Set<Marker>.from(widget.markers + myMarker),
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: initialLocation,
      onTap: _handleTap,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        newGoogleMapController = controller;
        locatePosition();
        _setMapStyle();
        getMarkers();
      },
    );
  }

  void _handleTap(LatLng tappedPosition) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
          markerId: MarkerId(tappedPosition.toString()),
          position: tappedPosition,
          draggable: true,
          onDragEnd: (dragEndPosition) {},
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
    });
  }

  getMarkers() {
    postService.getPosts(jwtToken!).then((value) {
      int i = 0;
      for (var element in value.data) {
        posts.add(Post.fromJson(element));
        User newUser = User.fromJson(posts[i].user);
        Sport newSport = Sport.fromJson(posts[i].sport);
        widget.markers.add(posts[i].toMarker(
            newUser.firstName,
            newUser.lastName,
            newSport.sport,
            posts[i].time,
            newUser.firebaseToken,
            newUser.imageURL,
            newUser.email,
            context));
        i++;
      }
      setState(() {});
    });
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future _setMapStyle() async {
    final controller = await _controller.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    if (theme == Brightness.dark) {
      controller.setMapStyle(_darkMapStyle);
    } else {
      controller.setMapStyle(_lightMapStyle);
    }
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 11);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
