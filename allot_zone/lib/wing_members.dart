import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Colors.dart';
import 'individual_wing_model.dart';

class WingMembers extends StatelessWidget {
  final WingModel selected;
  final List<WingModel> wingList = [];
  List<String> emailList = [];

  WingMembers({super.key, required this.selected}) {
    emailList = List.filled(2 * selected.wingSize.toInt() - 1, "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              itemCount: 2 * selected.wingSize.toInt() - 1,
              itemBuilder: ((context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text((index + 1).toString()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 300,
                            child: TextField(
                              onChanged: (value) => emailList[index] = value,
                              style: TextStyle(
                                color: MyColors.buttonTextColor,
                              ),
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColorLight)),
                                  labelText: 'Enter Email',
                                  labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight)),
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
              onPressed: () async {
                for (String i in emailList) {
                  if (!EmailValidator.validate(i)) {
                    showDialog(
                        context: context,
                        builder: ((context) => const AlertDialog(
                              title: Text("Error"),
                              content: Text("Enter valid emails"),
                              backgroundColor: Colors.blueGrey,
                            )));
                    return;
                  }
                }
                for (String i in emailList) {
                  final doc =
                      FirebaseFirestore.instance.collection("users").doc(i);
                  await doc.set({
                    'email': i,
                    'wingChosen':selected.wingId
                  });
                }
                selected.isAvailable = false;
                selected.setFill = Colors.grey;
                for (WingModel w in wingList) {
                  final doc = FirebaseFirestore.instance
                      .collection("vishwakarma")
                      .doc(w.wingId.toString());
                  doc.set(w.toJson());
                }
              },
              style: TextButton.styleFrom(
                  foregroundColor: MyColors.buttonTextColor),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
