import 'dart:developer';

import 'package:allot_zone/after_selection.dart';
import 'package:allot_zone/login_first_page.dart';
import 'package:allot_zone/room_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
              height: 600,
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
                  User? loggedIn = FirebaseAuth.instance.currentUser;
                  if (loggedIn == null) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: ((context) => FirstPage())));
                    return;
                  }

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
                  final uniqueEmail = emailList.toSet();
                  if (uniqueEmail.length!=emailList.length){
                    showDialog(
                          context: context,
                          builder: ((context) => const AlertDialog(
                                alignment: Alignment.center,
                                backgroundColor: Colors.grey,
                                content: Text("Please remove duplicate emails"),
                              )));
                      return;
                  }
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
                              loading(context);
                              for (String s in emailList) {
                                try {
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
                                                  "Student with ${s} has already chosen a room"),
                                            )));
                                    return;
                                  }
                                } on FirebaseAuthException catch (e) {}
                              }

                              int roomChosen = 0;
                              loading(context);
                              for (int i = 0; i < emailList.length; i++) {
                                if (emailList[i] == loggedIn.email) {
                                  roomChosen = selectedList[(i / 2).floor()];
                                }

                                final doc = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(emailList[i]);
                                try {
                                  
                                  await doc.set({
                                    'email': emailList[i],
                                    'roomChosen': selectedList[(i / 2).floor()]
                                  });
                                  final wing = FirebaseFirestore.instance
                                      .collection('vishwakarma')
                                      .doc(selectedList[(i / 2).floor()]
                                          .toString());
                                  await wing.set({'isAvailable': false});

                                } on FirebaseAuthException catch (e) {
                                  message(context, e.message.toString());
                                }
                              }
                              
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          AfterSelection(roomNo: roomChosen))));
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
