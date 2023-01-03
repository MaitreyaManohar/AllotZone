import 'dart:async';

import 'package:allot_zone/firstPage.dart';
import 'package:allot_zone/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(milliseconds: 1500),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const FirstPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child:  Text(
          "Start Screen",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}
