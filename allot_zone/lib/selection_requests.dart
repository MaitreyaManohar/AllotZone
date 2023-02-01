import 'package:allot_zone/Colors.dart';
import 'package:allot_zone/Components/side_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'after_selection.dart';
import 'login_first_page.dart';

class SelectionRequest extends StatelessWidget {
  const SelectionRequest({super.key});

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

  Future _future() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    if (data.data()!['requests'] == null) {
      return null;
    } else {
      return data;
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
          actions: [
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.transparent),
              onPressed: () async {
                loading(context);
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) => FirstPage())));
              },
              child: Text(
                'SignOut',
                style: TextStyle(color: MyColors.buttonTextColor),
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: _future(),
          builder: ((context, snapshot) {
            if (snapshot.data == null) {
              return const Center(child: Text("No requests"));
            } else if (snapshot.data!['requests'].isEmpty) {
              return const Center(child: Text("No requests"));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!['requests'].length,
                  itemBuilder: ((context, index) {
                    String sender =
                        snapshot.data!['requests'].keys.toList()[index];
                    int room = snapshot.data!['requests'][sender];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        minVerticalPadding: 10,
                        tileColor: MyColors.buttonBackground,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        title: Text(sender),
                        subtitle: Text(room.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                //Yes button
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => AlertDialog(
                                            backgroundColor: Colors.grey,
                                            content: const Text(
                                                "Confirm that you accept this request"),
                                            actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor: MyColors
                                                        .buttonBackground),
                                                onPressed: () async {
                                                  final doc2 = FirebaseFirestore
                                                      .instance
                                                      .collection('vishwakarma')
                                                      .doc(room.toString());
                                                  loading(context);
                                                  final data = await doc2.get();
                                                  Navigator.pop(context);
                                                  if (data.data()![
                                                          'isAvailable'] ==
                                                      false) {
                                                    message(context,
                                                        "Room $room has already been occupied");
                                                    return;
                                                  }

                                                  final List recipients =
                                                      data.data()!['requests']
                                                          [sender];
                                                  recipients.remove(FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .email);
                                                  final String roommate =
                                                      recipients[0];
                                                  final roomMateData =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(roommate)
                                                          .get();
                                                  if (roomMateData.data()![
                                                          'roomChosen'] !=
                                                      null) {
                                                    message(context,
                                                        "Your room mate $roommate has already chosen a room");
                                                    return;
                                                  }
                                                  if (roommate == sender) {
                                                    final senderDoc =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(sender)
                                                            .get();
                                                    if (senderDoc.data()![
                                                            'roomChosen'] ==
                                                        null) {
                                                      final docData =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .email);
                                                      final roomMatesData =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(roommate);
                                                      await roomMatesData.set(
                                                          {'roomChosen': room},
                                                          SetOptions(
                                                              merge: true));
                                                      await docData.set(
                                                          {'roomChosen': room},
                                                          SetOptions(
                                                              merge: true));
                                                      await doc2.set({
                                                        'isAvailable': false,
                                                        'residents': [
                                                          roommate,
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .email
                                                        ]
                                                      },SetOptions(merge: true));
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context).pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: ((context) =>
                                                                  AfterSelection(
                                                                      roomNo:
                                                                          room))));
                                                      return;
                                                    }
                                                  }
                                                  if (roomMateData.data()![
                                                          'accepted'] ==
                                                      null) {
                                                    message(context,
                                                        "Your room mate $roommate has not accepted the request yet\n. You will be assigned this room only once he accepts it");
                                                  }

                                                  if (roomMateData
                                                      .data()!['accepted']
                                                      .contains(sender)) {
                                                    final docData =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .email);
                                                    final roomMatesData =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(roommate);
                                                    await roomMatesData.set({
                                                      'roomChosen': room
                                                    }, SetOptions(merge: true));
                                                    await docData.set({
                                                      'roomChosen': room
                                                    }, SetOptions(merge: true));
                                                    await doc2.set({
                                                      'isAvailable': false,
                                                      'residents': [
                                                        roommate,
                                                        FirebaseAuth.instance
                                                            .currentUser!.email
                                                      ]
                                                    });
                                                    
                                                  }
                                                  Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              AfterSelection(
                                                                  roomNo:
                                                                      room))));
                                                },
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: MyColors
                                                          .buttonTextColor),
                                                ),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor: MyColors
                                                        .buttonBackground),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: MyColors
                                                          .buttonTextColor),
                                                ),
                                              ),
                                            ],
                                          )));
                                },
                                icon: const Icon(
                                  Icons.check,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.close)),
                          ],
                        ),
                      ),
                    );
                  }));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
  }
}
