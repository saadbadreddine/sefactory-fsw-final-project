import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hustle_app/utils/storage.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference requestsCollection =
      FirebaseFirestore.instance.collection('requests');

  Stream<QuerySnapshot> get requests {
    return requestsCollection.where('receiverID', isEqualTo: email).snapshots();
  }
}
