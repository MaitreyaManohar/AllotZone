import 'package:allot_zone/individual_wing.dart';
import 'package:allot_zone/wing_members.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Colors.dart';

class WingSelectionPage extends StatefulWidget {
  const WingSelectionPage({super.key});

  @override
  State<WingSelectionPage> createState() => _WingSelectionPageState();
}

class _WingSelectionPageState extends State<WingSelectionPage> {
  AlertDialog alert = const AlertDialog(
    title: Text("Alert"),
    content: Text("Please select a wing! "),
  );

  Color fill = const Color.fromARGB(0, 255, 193, 7);

  List<WingModel> wingList = [
    WingModel(wingId: 1, wingSize: 6, isHorizontal: true),
    WingModel(wingId: 2, wingSize: 7, isHorizontal: false),
    WingModel(wingId: 3, wingSize: 7, isHorizontal: true)
  ];

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
          InteractiveViewer(
            child: SizedBox(
              height: 600,
              child: ListView.builder(
                itemCount: wingList.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                      onTap: () {
                        setState(() {
                          print(wingList[index].wingId);
                          for (WingModel w in wingList) {
                            if (wingList[index] != w) {
                              w.setFill = const Color.fromARGB(0, 255, 193, 7);
                              w.isSelected = false;
                            }
                          }
                          wingList[index].onTapModel();
                        });
                      },
                      child: Wrap(children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Center(
                              child: Text(
                                wingList[index].wingSize.toString(),
                              ),
                            ),
                            width: wingList[index].getWidth,
                            height: wingList[index].getHeight,
                            decoration: BoxDecoration(
                                color: wingList[index].fill,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: MyColors.buttonColor,
                                  width: 3,
                                )),
                          ),
                        ),
                      ]));
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: const Text(
                "Next",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                var selected =
                    wingList.where((element) => element.isSelected == true);
                if (selected.isEmpty) {
                  showDialog(
                      context: context,
                      builder: ((BuildContext context) => alert));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WingMembers(selected: selected.first),
                    ),
                  );
                }
                // Navigator.push(context, MaterialPageRoute(builder: (context)=>const WingSelectionPage()));
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
