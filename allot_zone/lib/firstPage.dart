import 'package:allot_zone/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'AllotZone',
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Welcome to AllotZone: ',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorLight),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              style: TextStyle(
                color: MyColors.buttonColor,
              ),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight)),
                  labelText: 'Enter your Name',
                  labelStyle:
                      TextStyle(color: Theme.of(context).primaryColorLight)),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              style: TextStyle(
                color: MyColors.buttonColor,
              ),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight)),
                  labelText: 'Enter ID',
                  labelStyle:
                      TextStyle(color: Theme.of(context).primaryColorLight)),
            ),
          ),
          SizedBox(
            width: 300,
            child: TextField(
              style: TextStyle(
                color: MyColors.buttonColor,
              ),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight)),
                  labelText: 'Enter Password',
                  labelStyle:
                      TextStyle(color: Theme.of(context).primaryColorLight)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Text(
                "Next",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: MyColors.buttonColor),
            ),
          ),
          Row(children: [
            TextButton(
              child: const Text(
                "Login",
              ),
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: MyColors.linkColor),
            ),
            TextButton(
              child: const Text(
                "Manager?",
              ),
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: MyColors.linkColor),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,)
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
