import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hustle_app/widget/appbar_widget.dart';

import '../api/firestore_service.dart';
import '../utils/storage.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  void initState() {
    super.initState();
  }

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
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 55,
                              height: 55,
                              child: ClipOval(
                                child: Material(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  child: Image.network(
                                    data['imgURL'],
                                    height: 150.0,
                                    width: 100.0,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 15),
                                          child: Text(
                                            '${data['senderFirstName']} ${data['senderLastName']}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Align(
                            child: Text(
                              'Requested your phone number',
                              style: const TextStyle(fontSize: 16, height: 1.4),
                            ),
                            alignment: Alignment.center),
                        const SizedBox(height: 10),
                        ButtonBar(children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Accept',
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Reject',
                                style: TextStyle(
                                    fontSize: 15,
                                    color:
                                        Theme.of(context).colorScheme.error)),
                          ),
                        ])
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
    );
  }
}
