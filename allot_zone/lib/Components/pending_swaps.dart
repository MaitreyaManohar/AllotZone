import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Colors.dart';

class PendinSwaps extends StatefulWidget {
  const PendinSwaps({super.key});

  @override
  State<PendinSwaps> createState() => _PendinSwapsState();
}

class _PendinSwapsState extends State<PendinSwaps> {
  final Stream _usersStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        Map data = snapshot.data.data();
        if (!data.containsKey('swaprequests')) {
          return const Center(
            child: Text("No requests"),
          );
        }
        List roomSwapdata = data['swaprequests'].keys.toList();
        return ListView.builder(
          itemCount: roomSwapdata.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async{
                        
                      },
                      icon: const Icon(Icons.check),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                tileColor: MyColors.buttonBackground,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                title: Text(roomSwapdata[index]),
              ),
            );
          },
        );
      },
    );
  }
}
