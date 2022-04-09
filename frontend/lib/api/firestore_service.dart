import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hustle_app/model/notify_model.dart';
import 'package:hustle_app/utils/storage.dart';
import 'package:http/http.dart' as http;

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  Stream<QuerySnapshot> get requests {
    return requestsCollection.where('receiverID', isEqualTo: email).snapshots();
  }
}

sendNotification(Notification notification) async {
  String uri = apiURL + '/api/auth/notify';
  await http.post(Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
      body: json.encode(notification.toJson()));
}



/*sendNotification(receiverToken, firstName, lastName, message) async {
  print(receiverToken);
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': message,
          'title': '${firstName} ${lastName}',
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': receiverToken
      },
    ),
  ); 
}*/
