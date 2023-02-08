import 'dart:convert';

import 'package:allot_zone/Colors.dart';
import 'package:allot_zone/Components/side_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  void sendEmail(BuildContext context,
      {required String body,
      required String subject,
      required String toEmail}) async {
    final response = await http.post(
      Uri.parse(
          'https://allot-zone-backend-production.up.railway.app/mail/sendmail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "recipient": toEmail,
        "msgBody": "Dear $toEmail,\n\n$body \n\nBest wishes,\nTeam AllotZone",
        "subject": subject
      }),
    );
    if (response.statusCode != 200) {}
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
                Navigator.popUntil(context, (route) => route.isFirst);

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
                                onPressed: () async {
                                  final doc2 = FirebaseFirestore.instance
                                      .collection('vishwakarma')
                                      .doc(room.toString());
                                  loading(context);
                                  final data = await doc2.get();
                                  Navigator.pop(context);
                                  final List recipients =
                                      data.data()!['requests'][sender];
                                  recipients.remove(
                                      FirebaseAuth.instance.currentUser!.email);
                                  final String roommate = recipients[0];
                                  showDialog(
                                      context: context,
                                      builder: ((context) => AlertDialog(
                                            backgroundColor: Colors.grey,
                                            content: Text(
                                                "Your roommate is $roommate .\nConfirm that you accept this request"),
                                            actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor: MyColors
                                                        .buttonBackground),
                                                onPressed: () async {
                                                  loading(context);
                                                  final doc2 = FirebaseFirestore
                                                      .instance
                                                      .collection('vishwakarma')
                                                      .doc(room.toString());

                                                  if (data.data()![
                                                          'isAvailable'] ==
                                                      false) {
                                                    Navigator.pop(context);
                                                    message(context,
                                                        "Room $room has already been occupied");

                                                    return;
                                                  }

                                                  final roomMateData =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(roommate)
                                                          .get();
                                                  if (roomMateData.data()![
                                                          'roomChosen'] !=
                                                      null) {
                                                    Navigator.pop(context);
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
                                                      final userDataRead =
                                                          await docData.get();
                                                      Map userRequests =
                                                          userDataRead.data()![
                                                              'requests'];
                                                      userRequests
                                                          .remove(sender);
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
                                                          {
                                                            'roomChosen': room,
                                                            'requests':
                                                                userRequests
                                                          },
                                                          SetOptions(
                                                              merge: true));
                                                      await doc2.set(
                                                          {
                                                            'isAvailable':
                                                                false,
                                                            'residents': [
                                                              roommate,
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .email
                                                            ]
                                                          },
                                                          SetOptions(
                                                              merge: true));
                                                      sendEmail(context,
                                                          body:
                                                              "Congratulations!You have been allotted room $room.",
                                                          subject:
                                                              "Successful room allotment",
                                                          toEmail: FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .email!);
                                                      sendEmail(context,
                                                          body:
                                                              "Congratulations!You have been allotted room $room.",
                                                          subject:
                                                              "Successful room allotment",
                                                          toEmail: roommate);
                                                      Navigator.pop(context);
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

                                                  if (roomMateData
                                                      .data()!['requests']
                                                      .keys
                                                      .toList()
                                                      .contains(sender)) {
                                                    final docData =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .email);
                                                    final userDataRead =
                                                        await docData.get();
                                                    Map userRequests =
                                                        userDataRead.data()![
                                                            'requests'];
                                                    print(userRequests);
                                                    userRequests.remove(sender);
                                                    await docData.set({
                                                      'requests': userRequests
                                                    }, SetOptions(merge: true));
                                                    Navigator.pop(context);
                                                    Navigator.of(context).pop();
                                                    message(context,
                                                        "Your room mate $roommate has not accepted the request yet\n. You will be assigned this room only once he accepts it");

                                                    return;
                                                  } else {
                                                    final docData =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .email);
                                                    final userDataRead =
                                                        await docData.get();
                                                    Map userRequests =
                                                        userDataRead.data()![
                                                            'requests'];
                                                    userRequests.remove(sender);
                                                    final roomMatesData =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(roommate);
                                                    final roommateDataRead =
                                                        await roomMatesData
                                                            .get();
                                                    Map roomMateRequests =
                                                        roommateDataRead
                                                                .data()![
                                                            'requests'];
                                                    userRequests.remove(sender);
                                                    await roomMatesData.set({
                                                      'roomChosen': room,
                                                      'requests':
                                                          roomMateRequests
                                                    }, SetOptions(merge: true));
                                                    await docData.set({
                                                      'roomChosen': room,
                                                      'requests': userRequests
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
                                                  sendEmail(context,
                                                      body:
                                                          "Congratulations!You have been allotted room $room.",
                                                      subject:
                                                          "Successful room allotment",
                                                      toEmail: FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .email!);
                                                  sendEmail(context,
                                                      body:
                                                          "Congratulations!You have been allotted room $room.",
                                                      subject:
                                                          "Successful room allotment",
                                                      toEmail: roommate);
                                                  Navigator.pop(context);
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
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.grey,
                                      content: const Text(
                                          "Are you sure you want to reject the request?"),
                                      actions: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  MyColors.buttonBackground),
                                          onPressed: () async {
                                            final doc2 = FirebaseFirestore
                                                .instance
                                                .collection('vishwakarma')
                                                .doc(room.toString());
                                            loading(context);
                                            final data = await doc2.get();
                                            Navigator.pop(context);
                                            final List recipients = data
                                                .data()!['requests'][sender];
                                            recipients.remove(FirebaseAuth
                                                .instance.currentUser!.email);
                                            final String roommate =
                                                recipients[0];
                                            if (roommate != sender) {
                                              loading(context);
                                              final roomMateDoc =
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(roommate);
                                              final roomMateDocdata =
                                                  await roomMateDoc.get();
                                              Map tobeChangedforRoommate =
                                                  roomMateDocdata
                                                      .data()!['requests'];
                                              tobeChangedforRoommate
                                                  .remove(sender);
                                              await roomMateDoc.set(
                                                {
                                                  'requests':
                                                      tobeChangedforRoommate
                                                },
                                                SetOptions(merge: true),
                                              );
                                              final userDoc = FirebaseFirestore
                                                  .instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.email);
                                              final userDocData =
                                                  await userDoc.get();
                                              Map tobeChangedforUser =
                                                  userDocData
                                                      .data()!['requests'];
                                              tobeChangedforUser.remove(sender);
                                              await userDoc.set({
                                                'requests': tobeChangedforUser
                                              }, SetOptions(merge: true));
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          SelectionRequest())));
                                            } else {
                                              loading(context);
                                              final userDoc = FirebaseFirestore
                                                  .instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.email);
                                              final userDocData =
                                                  await userDoc.get();
                                              Map tobeChangedforUser =
                                                  userDocData
                                                      .data()!['requests'];
                                              tobeChangedforUser.remove(sender);
                                              await userDoc.set({
                                                'requests': tobeChangedforUser
                                              }, SetOptions(merge: true));
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          SelectionRequest())));
                                            }
                                          },
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                                color:
                                                    MyColors.buttonTextColor),
                                          ),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  MyColors.buttonBackground),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                color:
                                                    MyColors.buttonTextColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
