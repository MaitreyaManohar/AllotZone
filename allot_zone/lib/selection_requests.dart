import 'package:allot_zone/Components/side_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SelectionRequest extends StatelessWidget {
  const SelectionRequest({super.key});

  Future<Map<String, int>> getData() async {
    final collection = FirebaseFirestore.instance.collection('users');
    final doc = collection.doc(FirebaseAuth.instance.currentUser!.email);
    final data = await doc.get();
    if (data.data() == null || data.data()!['requests'] == null) {
      return {};
    } else {
      return data.data()!['requests'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideBar(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'AllotZone',
          ),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: ((context, snapshot) {
            return const Text("Hello");
          }),
        ));
  }
}
