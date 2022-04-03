import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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

sendNotification(receiverToken, firstName, lastName) async {
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
          'body': '${firstName} ${lastName}',
          'title': 'Request Received',
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
}
