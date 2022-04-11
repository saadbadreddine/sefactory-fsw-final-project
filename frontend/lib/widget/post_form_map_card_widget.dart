import 'package:dropdown_button2/dropdown_button2.dart';
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

  String? selectedValue;
  List<String> items = [
    'Basketball',
    'Football',
  ];

  bool _dropDownIsError = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.fromLTRB(20, 90, 20, 190),
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
            key: _formKey,
            child: Container(
              constraints: _widthConstraints,
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Icon(
                        Icons.sports_basketball,
                        color: Theme.of(context).hintColor,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: const [
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Select Sport',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              _dropDownIsError = false;
                              selectedValue = value as String;
                              if (selectedValue == "Basketball") {
                                postRequest.sportID = 1;
                              } else if (selectedValue == "Football") {
                                postRequest.sportID = 2;
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_drop_down_outlined,
                          ),
                          iconEnabledColor:
                              Theme.of(context).colorScheme.primary,
                          iconDisabledColor: Theme.of(context).disabledColor,
                          buttonHeight: 65,
                          buttonWidth: 297,
                          buttonPadding:
                              const EdgeInsets.only(left: 10, right: 14),
                          buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: !_dropDownIsError
                                      ? Theme.of(context).backgroundColor
                                      : Theme.of(context).errorColor,
                                  width: 1.2),
                              color: Theme.of(context).bottomAppBarColor),
                          itemHeight: 40,
                          itemPadding:
                              const EdgeInsets.only(left: 30, right: 14),
                          dropdownMaxHeight: 200,
                          dropdownWidth: 250,
                          dropdownPadding: null,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Theme.of(context).cardColor,
                          ),
                          dropdownElevation: 8,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 6,
                          scrollbarAlwaysShow: true,
                          offset: const Offset(5, -3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a valid announcement';
                      } else {
                        return null;
                      }
                    },
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
                    postRequest.sportID == 0
                        ? _dropDownIsError = true
                        : _dropDownIsError = false;
                    setState(() {});
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _formKey.currentState!.save();
                      });
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
                        Navigator.pop(context, 'OK');
                      });
                    } else {}
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
