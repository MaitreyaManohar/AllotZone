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
      body: Center(
        child: Text("You have selected room VK$roomNo"),
      ),
    );
  }
}
