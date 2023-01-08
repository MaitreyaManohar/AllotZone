import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AfterSelection extends StatelessWidget {
  String? email;
  int wingChosen;
  AfterSelection({super.key, required this.wingChosen}) {
    final u = FirebaseAuth.instance.currentUser;
    final doc = FirebaseFirestore.instance.collection('users').doc(u!.email);
    email = u.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('AllotZone'),
      ),
      body: Center(
        child: Text(
          'You have chosen wing $wingChosen',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
