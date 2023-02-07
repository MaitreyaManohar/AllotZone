import 'dart:convert';

import 'package:allot_zone/login_first_page.dart';
import 'package:allot_zone/room_select.dart';
import 'package:allot_zone/selection_requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Colors.dart';

class WingMembers extends StatelessWidget {
  final List selectedList;
  const WingMembers({super.key, required this.selectedList});

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
    if (response.statusCode != 200) {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> emailList =
        List.generate(2 * selectedList.length, (index) => " ");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'AllotZone',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.8,
              child: ListView.builder(
                itemCount: selectedList.length,
                itemBuilder: ((context, index) {
                  // return Text(index.toString());
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: ((value) => emailList[2 * index] = value),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  borderSide: BorderSide(
                                    color: MyColors.textFieldBorder,
                                  )),
                              labelText:
                                  "Enter email of resident 1 in ${selectedList[index]}",
                              labelStyle: TextStyle(color: MyColors.textColor)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: ((value) =>
                              emailList[2 * index + 1] = value),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  borderSide: BorderSide(
                                    color: MyColors.textFieldBorder,
                                  )),
                              labelText:
                                  "Enter email of resident 2 in ${selectedList[index]}",
                              labelStyle: TextStyle(color: MyColors.textColor)),
                        ),
                      ),
                      const Divider()
                    ],
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                //Confirm emails button
                onPressed: () async {
                  print(emailList);
                  User? loggedIn = FirebaseAuth.instance.currentUser;
                  if (loggedIn == null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: ((context) => FirstPage())));
                    return;
                  }
                  try {
                    for (int i in selectedList) {
                      final collection =
                          FirebaseFirestore.instance.collection('vishwakarma');
                      final doc = collection.doc(i.toString());
                      final data = await doc.get();
                      if (!data.data()!['isAvailable']) {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => const RoomSelection())));
                        showDialog(
                            context: context,
                            builder: ((context) => AlertDialog(
                                  backgroundColor: Colors.grey,
                                  content: Text(
                                      "Someone has already chosen room VK$i"),
                                )));
                        return;
                      }
                    }
                  } on Exception catch (e) {
                    message(context, e.toString());
                  }
                  print("Checked chosen room");
                  final uniqueEmail = emailList.toSet();
                  if (uniqueEmail.length != emailList.length) {
                    showDialog(
                        context: context,
                        builder: ((context) => const AlertDialog(
                              alignment: Alignment.center,
                              backgroundColor: Colors.grey,
                              content: Text("Please remove duplicate emails"),
                            )));
                    return;
                  }
                  print("Checked duplicate emails ");

                  for (String s in emailList) {
                    if (!EmailValidator.validate(s)) {
                      showDialog(
                          context: context,
                          builder: ((context) => const AlertDialog(
                                alignment: Alignment.center,
                                backgroundColor: Colors.grey,
                                content: Text("Please enter valid emails"),
                              )));
                      return;
                    }
                  }

                  print("Checked validity of emails");

                  if (!emailList.contains(loggedIn.email)) {
                    showDialog(
                        context: context,
                        builder: ((context) => const AlertDialog(
                              alignment: Alignment.center,
                              backgroundColor: Colors.grey,
                              content: Text(
                                  "Your email has to be included in one of these rooms"),
                            )));
                    return;
                  }

                  //Dialog to show confirmation message on emails
                  showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        backgroundColor: Colors.grey,
                        content: const Text(
                            "Please confirm emails and then click on yes"),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: MyColors.buttonBackground),
                            onPressed: () async {
                              try {
                                for (String s in emailList) {
                                  final doc = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(s);
                                  final data = await doc.get();
                                  if (data.data() != null &&
                                      data.data()!['roomChosen'] != null) {
                                    showDialog(
                                        context: context,
                                        builder: ((context) => AlertDialog(
                                              alignment: Alignment.center,
                                              backgroundColor: Colors.grey,
                                              content: Text(
                                                  "Student with $s has already chosen a room"),
                                            )));
                                    return;
                                  }
                                }
                                Map toBeAdded = {};

                                for (int i = 0; i < selectedList.length; i++) {
                                  toBeAdded[selectedList[i].toString()] = [
                                    emailList[2 * i],
                                    emailList[2 * i + 1]
                                  ];
                                }

                                //Add a loading
                                for (int i = 0; i < emailList.length; i++) {
                                  final doc = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(emailList[i]);
                                  final doc2 = FirebaseFirestore.instance
                                      .collection('vishwakarma')
                                      .doc(selectedList[(i / 2).floor()]
                                          .toString());
                                  if (emailList[i] != loggedIn.email) {
                                    await doc.set({
                                      'email': emailList[i],
                                      'requests': {
                                        loggedIn.email:
                                            selectedList[(i / 2).floor()]
                                      }
                                    }, SetOptions(merge: true));
                                    sendEmail(context,
                                        body:
                                            "Request from ${loggedIn.email} has been sent for room ${selectedList[(i / 2).floor()]}. Please accept or reject the request through the app.",
                                        subject: "Room request",
                                        toEmail: emailList[i]);
                                    if (i % 2 == 0) {
                                      await doc2.set({
                                        'requests': {
                                          loggedIn.email: [
                                            emailList[i],
                                            emailList[i + 1]
                                          ]
                                        }
                                      }, SetOptions(merge: true));
                                    }
                                  } else if (emailList[i] == loggedIn.email) {
                                    final doc3 = FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(loggedIn.email);

                                    await doc3.set({'sentRequest': toBeAdded},
                                        SetOptions(merge: true));
                                    if (i % 2 == 0) {
                                      await doc2.set({
                                        'requests': {
                                          loggedIn.email: [
                                            emailList[i],
                                            emailList[i + 1]
                                          ]
                                        }
                                      }, SetOptions(merge: true));
                                    }
                                  }
                                }
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const SelectionRequest())));
                              } on Exception catch (e) {
                                message(context, e.toString());
                              }

                              //This part is to set selected rooms
                              // int roomChosen = 0;
                              // loading(context);
                              // for (int i = 0; i < emailList.length; i++) {
                              //   if (emailList[i] == loggedIn.email) {
                              //     roomChosen = selectedList[(i / 2).floor()];
                              //   }

                              //   final doc = FirebaseFirestore.instance
                              //       .collection('users')
                              //       .doc(emailList[i]);
                              //   try {

                              //     await doc.set({
                              //       'email': emailList[i],
                              //       'roomChosen': selectedList[(i / 2).floor()]
                              //     });
                              //     final wing = FirebaseFirestore.instance
                              //         .collection('vishwakarma')
                              //         .doc(selectedList[(i / 2).floor()]
                              //             .toString());
                              //     await wing.set({'isAvailable': false});

                              //   } on FirebaseAuthException catch (e) {
                              //     message(context, e.message.toString());
                              //   }
                              // }

                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();

                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: ((context) =>
                              //             AfterSelection(roomNo: roomChosen))));
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: MyColors.buttonTextColor),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: MyColors.buttonBackground),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'No',
                              style: TextStyle(color: MyColors.buttonTextColor),
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      MyColors.buttonBackground),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Text(
                  "Confirm emails",
                  style: TextStyle(
                    color: MyColors.buttonTextColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
