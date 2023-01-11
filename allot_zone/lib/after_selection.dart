import 'package:allot_zone/login_first_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AfterSelection extends StatelessWidget {
  final int roomNo;

  const AfterSelection({super.key, required this.roomNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'AllotZone',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.home,
        ),
        onPressed: () {

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: ((context) => FirstPage())));
        },
      ),
      body: Center(
        child: Text(
          "You have selected room VK$roomNo",
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
