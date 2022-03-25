import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const _widthConstraints = BoxConstraints(maxWidth: 400);

class TestEnv extends StatefulWidget {
  const TestEnv({Key? key}) : super(key: key);

  @override
  _TestEnvState createState() => _TestEnvState();
}

class _TestEnvState extends State<TestEnv> {
  final _textEditingController = TextEditingController();
  String? _jwt = '';
  String? _firebaseToken = '';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _jwt = dotenv.env['JWT_TOKEN'];
    _firebaseToken = dotenv.env['FIREBASE_TOKEN'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          constraints: _widthConstraints,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 100,
              height: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    textAlign: TextAlign.center,
                    child: Text('JWT: $_firebaseToken'))),
            const SizedBox(height: 10),
            DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium!,
                textAlign: TextAlign.center,
                child: Text('Firebase: $_jwt')),
          ]),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
