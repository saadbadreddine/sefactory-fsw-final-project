import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hustle_app/utils/storage.dart';
import 'package:hustle_app/widget/appbar_widget.dart';

class TestEnv extends StatefulWidget {
  const TestEnv({Key? key}) : super(key: key);

  @override
  _TestEnvState createState() => _TestEnvState();
}

class _TestEnvState extends State<TestEnv> {
  static const _widthConstraints = BoxConstraints(maxWidth: 400);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'Test'),
      body: Center(
        child: Container(
          constraints: _widthConstraints,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 100,
              height: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    textAlign: TextAlign.center,
                    child: Text('JWT: $jwtToken'))),
            const SizedBox(height: 10),
            DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium!,
                textAlign: TextAlign.center,
                child: Text('Firebase: $firebaseToken')),
          ]),
        ),
      ),
      floatingActionButton: SizedBox(
        //width: 70.0,
        //height: 70.0,
        child: FloatingActionButton(
          onPressed: () {
            createDocument();
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(Icons.create,
              color: Theme.of(context).colorScheme.onSecondary /*size: 30*/
              ),
        ),
      ),
    );
  }

  Future createDocument() async {
    final refMessage = FirebaseFirestore.instance
        .collection('chats')
        .doc('6dVs6GsoaXiJIzN7ybRU')
        .collection('messages')
        .doc();
    await refMessage.set({'message': 'Testin dis', 'user_id': firebaseToken});

    final refConnection = FirebaseFirestore.instance.collection('chats').doc();
    await refConnection.set({
      'sender_id': firebaseToken,
      'receiver_id': '',
      'is_accepted': false,
    });
  }
}
