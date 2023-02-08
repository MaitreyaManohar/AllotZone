import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Colors.dart';
import 'login_first_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  void message(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: Text(message),
              backgroundColor: Colors.grey,
            )));
  }

  void loading(BuildContext context) {
    //Loading Progress indicator
    showDialog(
        context: context,
        builder: ((context) => const Center(
              child: CircularProgressIndicator(),
            )));
  }

  void sendEmail(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('vishwakarma').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              bool isAvailable = snapshot.data!.docs[index]['isAvailable'];
              String roomNo = snapshot.data!.docs[index].reference.id;
              List residents =
                  (snapshot.data!.docs[index].data()['residents'] == null)
                      ? []
                      : snapshot.data!.docs[index].data()['residents'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  style: ListTileStyle.drawer,
                  title: (residents.isEmpty)
                      ? Text(roomNo)
                      : Text("$roomNo - ${residents[0]} and ${residents[1]}"),
                  tileColor: isAvailable ? Colors.amber : Colors.grey,
                  trailing: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: isAvailable?Color.fromARGB(255, 255, 98, 98):MyColors.buttonBackground),
                    onPressed: () async {
                      loading(context);
                      final roomDoc = FirebaseFirestore.instance
                          .collection('vishwakarma')
                          .doc(roomNo);

                      if (isAvailable) {
                        await roomDoc
                            .set({'isAvailable': false}, SetOptions(merge: true));
                        Navigator.pop(context);
                        return;
                      } else {
                        if (residents.isNotEmpty) {
                          final residentDoc1 = FirebaseFirestore.instance
                              .collection('users')
                              .doc(snapshot.data!.docs[index]['residents'][0]);
                          await residentDoc1.set({
                            'roomChosen': FieldValue.delete(),
                            'sentRequest': FieldValue.delete(),
                          }, SetOptions(merge: true));
                          final residentDoc2 = FirebaseFirestore.instance
                              .collection('users')
                              .doc(snapshot.data!.docs[index]['residents'][1]);
                          await residentDoc2.set({
                            'roomChosen': FieldValue.delete(),
                            'sentRequest': FieldValue.delete(),
                          }, SetOptions(merge: true));
                          sendEmail(
                              body:
                                  "Your room has been vacated by the admin. Please choose another room as soon as possible",
                              subject: "Room Vacated by admin",
                              toEmail: snapshot.data!.docs[index]['residents']
                                  [0]);
                          sendEmail(
                              body:
                                  "Your room has been vacated by the admin. Please choose another room as soon as possible",
                              subject: "Room Vacated by admin",
                              toEmail: snapshot.data!.docs[index]['residents']
                                  [1]);
                        }
                        await roomDoc.set({
                          'isAvailable': true,
                          'residents': FieldValue.delete()
                        }, SetOptions(merge: true));
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      !isAvailable ? 'Vacate' : 'Block',
                      style: TextStyle(color: isAvailable?Colors.black:MyColors.buttonTextColor),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
