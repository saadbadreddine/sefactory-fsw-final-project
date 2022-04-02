import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hustle_app/api/post_service.dart';
import 'package:hustle_app/model/post_model.dart';
import 'package:hustle_app/utils/storage.dart';

const _widthConstraints = BoxConstraints(maxWidth: 340);

class PostFormWidget extends StatefulWidget {
  final String lat;
  final String long;
  final VoidCallback onPostCreated;

  const PostFormWidget(
      {Key? key,
      required this.lat,
      required this.long,
      required this.onPostCreated})
      : super(key: key);

  @override
  State<PostFormWidget> createState() => PostFormWidgetState();
}

class PostFormWidgetState extends State<PostFormWidget>
    with WidgetsBindingObserver {
  PostRequest postRequest =
      PostRequest(lat: '', long: '', message: '', sportID: 0, time: '');
  PostService postService = PostService();
  Marker? newMarker;

  final TextEditingController _dateCtl = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Basketball"), value: "Basketball"),
      const DropdownMenuItem(child: Text("Football"), value: "Football"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.fromLTRB(20, 100, 20, 200),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 10.0),
            child: Row(
              children: [
                Text(
                  'Post',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          Form(
            child: Container(
              constraints: _widthConstraints,
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  TextFormField(
                    onChanged: (text) {
                      postRequest.sportID = 1;
                    },
                    decoration: InputDecoration(
                      labelText: 'Sport',
                      icon: const Icon(Icons.sports_basketball),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      await showTimePicker(
                        context: context,
                        initialEntryMode: TimePickerEntryMode.input,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        if (value != null) {
                          //print(date.toIso8601String());

                          final localizations =
                              MaterialLocalizations.of(context);
                          final formattedTimeOfDay =
                              localizations.formatTimeOfDay(value);
                          postRequest.time = formattedTimeOfDay;
                          _dateCtl.text = formattedTimeOfDay;
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the time the game will be held';
                      }
                      return null;
                    },
                    onSaved: (input) => postRequest.time = input!,
                    controller: _dateCtl,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                      //enabled: false,
                      labelText: 'Time',
                      icon: const Icon(Icons.more_time),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onChanged: (text) {
                      postRequest.message = text;
                    },
                    minLines: 3,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Announcement',
                      icon: const Icon(Icons.campaign_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    postRequest.lat = widget.lat;
                    postRequest.long = widget.long;
                    postService.post(postRequest, jwtToken!).then((value) {
                      newMarker = Marker(
                        markerId: MarkerId(value.postID.toString()),
                        position: LatLng(double.parse(widget.lat),
                            double.parse(widget.long)),
                        infoWindow: const InfoWindow(title: ""),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueViolet),
                      );
                      widget.onPostCreated();
                    });
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text(
                    'Post Announcement',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('Dismiss',
                      style: TextStyle(
                        fontSize: 15,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
