import 'package:allot_zone/Colors.dart';
import 'package:allot_zone/Components/side_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'after_selection.dart';
import 'login_first_page.dart';

class SwapRequest extends StatelessWidget {
  const SwapRequest({super.key});

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
        ));
  }
}