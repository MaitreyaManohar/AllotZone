import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Colors.dart';

class NewSwap extends StatelessWidget {
  const NewSwap({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        
        obscureText: true,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(
                  color: MyColors.textFieldBorder,
                )),
            labelText: "Enter password",
            labelStyle: TextStyle(color: MyColors.textColor)),
      ),
    );
  }
}
