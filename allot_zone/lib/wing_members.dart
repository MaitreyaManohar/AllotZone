import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Colors.dart';
import 'individual_wing.dart';

class WingMembers extends StatelessWidget {
  WingModel selected;
  WingMembers({super.key, required this.selected});

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
          SizedBox(
            height: 600,
            child: ListView.builder(
              itemCount: 2*selected.wingSize-1,
              itemBuilder: ((context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text((index+1).toString()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
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
                              labelText: 'Enter Name',
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
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                selected.isAvailable=false;
                selected.setFill = Colors.grey;
              },
              style:
                  TextButton.styleFrom(foregroundColor: MyColors.buttonColor),
            ),
          ),
        ],
      ),
    );
  }
}
