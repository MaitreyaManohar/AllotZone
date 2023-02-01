import 'package:allot_zone/Components/side_bar.dart';
import 'package:allot_zone/login_first_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Colors.dart';

class AfterSelection extends StatelessWidget {
  final int roomNo;
  void loading(BuildContext context) {
    //Loading Progress indicator
    showDialog(
        context: context,
        builder: ((context) => const Center(
              child: CircularProgressIndicator(),
            )));
  }

  const AfterSelection({super.key, required this.roomNo});

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
      body: Center(
        child: Text(
          "Congratulations !\nYou have selected room VK$roomNo",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
