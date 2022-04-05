import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hustle_app/widget/appbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../api/firestore_service.dart';
import '../utils/storage.dart';

class RequestsPage extends StatefulWidget {
  const RequestsPage({Key? key}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  late String senderEmail;

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
                senderEmail = data['senderID'];
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
                        const Align(
                            child: Text(
                              'Requested to join your game, accept this request to get redirected to whatsapp and plan your game',
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ),
                            alignment: Alignment.center),
                        const SizedBox(height: 10),
                        ButtonBar(children: [
                          TextButton(
                            onPressed: () {
                              print(data['senderPhoneNumber']);
                              launchWhatsApp(data['phoneNumber']);
                            },
                            child: const Text('Accept',
                                style: TextStyle(
                                  fontSize: 15,
                                )),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => SizedBox(
                                  width: 300,
                                  height: 400,
                                  child: AlertDialog(
                                    title: const Text('Alert'),
                                    content: const Text(
                                        'Are you sure you want to reject and delete this request?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                          rejectDeleteRequest(
                                              senderEmail, email);
                                        },
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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

  rejectDeleteRequest(senderEmail, email) async {
    var collection = FirebaseFirestore.instance.collection('requests');
    var snapshot = await collection
        .where('senderID', isEqualTo: senderEmail)
        .where('receiverID', isEqualTo: email)
        .get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  launchWhatsApp(phoneNumber) async {
    final link = WhatsAppUnilink(
      phoneNumber: '96170979734',
      text: "Hey i saw your request",
    );
    await launch('$link');
  }
}
