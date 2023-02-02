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

  void loading(BuildContext context) {
    //Loading Progress indicator
    showDialog(
        context: context,
        builder: ((context) => const Center(
              child: CircularProgressIndicator(),
            )));
  }

  void message(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: Text(message),
              backgroundColor: Colors.grey,
            )));
  }

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
        Map mapdata = snapshot.data.data();
        if (!mapdata.containsKey('swaprequests')) {
          return const Center(
            child: Text("No requests"),
          );
        }
        List roomSwapdata = mapdata['swaprequests'];
        return ListView.builder(
          itemCount: roomSwapdata.length,
          itemBuilder: (context, index) {
            return StreamBuilder<Object>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(roomSwapdata[index])
                    .snapshots(),
                builder: (context, snapshot1) {
                  dynamic snapshot2 = snapshot1 as dynamic;

                  if (snapshot2.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  final requesterData = snapshot2.data.data();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final userDoc = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(
                                      FirebaseAuth.instance.currentUser!.email);
                              final userDocdata = await userDoc.get();

                              final roomDataDoc = FirebaseFirestore.instance
                                  .collection('vishwakarma')
                                  .doc(requesterData['roomChosen'].toString());
                              final roomData = await roomDataDoc.get();
                              List residents = roomData.data()!['residents'];
                              residents.remove(
                                  FirebaseAuth.instance.currentUser!.email);
                              String roommate = residents[0];

                              final roommateDoc = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(roommate);
                              final roomMateData = await roommateDoc.get();
                              List userDocList =
                                  (userDocdata.data()!['acceptedswaps'] == null)
                                      ? []
                                      : userDocdata.data()!['acceptedswaps'];
                              userDocList.add(
                                  FirebaseAuth.instance.currentUser!.email);
                              roomSwapdata.remove(roomSwapdata[index]);
                              print(roomSwapdata);
                              message(context, "You accepted");
                              await userDoc.set({
                                'acceptedrequests': userDocList,
                                'swaprequests': roomSwapdata
                              }, SetOptions(merge: true));
                              bool _acceptedCheck =
                                  roomMateData.data()!['acceptedswaps'] == null;
                              if (roomMateData
                                      .data()!['acceptedswaps']
                                      .contains(roomSwapdata[index]) &&
                                  !_acceptedCheck) {
                                    
                                  }
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
                      title: Text(requesterData['roomChosen'].toString()),
                    ),
                  );
                });
          },
        );
      },
    );
  }
}
