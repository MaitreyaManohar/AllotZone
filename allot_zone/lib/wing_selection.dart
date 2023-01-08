import 'package:allot_zone/individual_wing_model.dart';
import 'package:allot_zone/wing_members.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Colors.dart';

class WingSelection extends StatefulWidget {
  const WingSelection({super.key});

  @override
  State<WingSelection> createState() => _WingSelectionState();
}

class _WingSelectionState extends State<WingSelection> {
  List<WingModel> wingList = [];

  Future getListData() async {
    if (wingList.isEmpty) {
      var collection = FirebaseFirestore.instance.collection("vishwakarma");
      var querySnapshot = await collection.get();
      for (var w in querySnapshot.docs) {
        Map<String, dynamic> data = w.data();
        wingList.add(WingModel.fromJson(data));
      }
    } else
      return;
  }

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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InteractiveViewer(
            child: SizedBox(
              height: 400,
              child: FutureBuilder(
                  future: getListData(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: wingList.length,
                      itemBuilder: ((context, index) {
                        return Wrap(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (wingList[index].fill != Colors.amber) {
                                      wingList[index].setFill = Colors.amber;
                                      wingList[index].setIsSelected = true;
                                    } else {
                                      wingList[index].setFill =
                                          const Color.fromARGB(0, 255, 193, 7);
                                      wingList[index].setIsSelected = false;
                                    }
                                    for (WingModel w in wingList) {
                                      if (wingList[index] != w) {
                                        w.setFill = const Color.fromARGB(
                                            0, 255, 193, 7);
                                        w.isSelected = false;
                                      }
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: wingList[index].isHorizontal
                                        ? 100
                                        : 50 * wingList[index].wingSize,
                                    width: wingList[index].isHorizontal
                                        ? 50 * wingList[index].wingSize
                                        : 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: wingList[index].isAvailable
                                            ? wingList[index].fill
                                            : Colors.grey,
                                        border: Border.all(
                                            color: MyColors.buttonTextColor)),
                                  ),
                                )),
                          ],
                        );
                      }),
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextButton(
              onPressed: () async {
                for (WingModel w in wingList) {
                  final doc = FirebaseFirestore.instance
                      .collection("vishwakarma")
                      .doc(w.wingId.toString());
                  doc.set(w.toJson());
                }
                var selected =
                    wingList.where((element) => element.isSelected == true);
                if (selected.isEmpty) {
                  showDialog(
                      context: context,
                      builder: ((BuildContext context) => const AlertDialog(
                            title: Text("Alert!"),
                            content: Text("Please select a wing!"),
                            backgroundColor: Colors.grey,
                          )));
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WingMembers(selected: selected.first),
                    ),
                  );
                }
              },
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
                "Confirm Selection",
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

