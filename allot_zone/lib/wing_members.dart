import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Colors.dart';

class WingMembers extends StatelessWidget {
  final List selectedList;
  const WingMembers({super.key, required this.selectedList});

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
              itemCount: selectedList.length,
              itemBuilder: ((context, index) {
                // return Text(index.toString());
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
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
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
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
              onPressed: null,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(MyColors.buttonBackground),
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
    );
  }
}
