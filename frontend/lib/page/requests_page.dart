import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hustle_app/widget/appbar_widget.dart';

import '../api/firestore_service.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Requests',
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().requests,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
              'Something went wrong',
              style: TextStyle(fontSize: 16),
            ));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data?.size == 0) {
            return const Center(
                child: Text(
              'Nothing to show here ...',
              style: TextStyle(fontSize: 16),
            ));
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                child: Text(data['senderID']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
