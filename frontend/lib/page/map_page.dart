import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hustle_app/widget/appbar_widget.dart';

import '../widget/post_form_map_card_widget.dart';
import '/widget/map_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final GlobalKey<MapState> _myKey = GlobalKey();
  final GlobalKey<PostFormWidgetState> _myFormKey = GlobalKey();

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Map'),
      body: Map(key: _myKey, markers: markers),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              _myKey.currentState?.locatePosition();
            },
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(Icons.my_location,
                color: Theme.of(context).colorScheme.onSecondary),
          ),
          const SizedBox(
            height: 15,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              if (_myKey.currentState!.myMarker.isEmpty) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Tip'),
                    content: const Text(
                        'Drop a pin by tapping on the map before posting.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Dismiss'),
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
                );
              } else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => PostFormWidget(
                    key: _myFormKey,
                    lat: _myKey.currentState!.myMarker[0].position.latitude
                        .toString(),
                    long: _myKey.currentState!.myMarker[0].position.longitude
                        .toString(),
                    onPostCreated: () {
                      _myKey.currentState!.myMarker = [];
                      markers.add(_myFormKey.currentState!.newMarker!);
                      setState(() {});
                    },
                  ),
                );
              }
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.create,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
