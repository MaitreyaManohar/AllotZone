import 'package:allot_zone/admin_page.dart';
import 'package:allot_zone/after_selection.dart';
import 'package:allot_zone/room_select.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'login_first_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? loggedIn = FirebaseAuth.instance.currentUser;

  Future<Widget> initialWidget() async {
    if (loggedIn == null) {
      return FirstPage();
    }
    if(loggedIn!.uid=='MpGdSsumKRTu6kFOWiO9HWwY77w2'){
      return const AdminPage();
    }
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(loggedIn!.email);
    final userData = await userDoc.get();
    if (userData.data()!['roomChosen'] == null) {
      return const RoomSelection();
    } else {
      return AfterSelection(roomNo: userData.data()!['roomChosen']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: const Text(
        "AllotZone",
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255)),
      ),
      nextScreen: FutureBuilder(
        future: initialWidget(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Loading.."),
            );
          }
          return snapshot.data!;
        },
      ),
      duration: 1500,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
