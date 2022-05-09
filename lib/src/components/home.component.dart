import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_application/src/services/firebase.service.dart';

class HomeComponent extends StatefulWidget {
  @override
  State<HomeComponent> createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              _firebaseService.signOut();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [Text('Home')],
          ),
        )
    );
  }
}
