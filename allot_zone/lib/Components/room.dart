import 'package:allot_zone/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Room extends StatefulWidget {
  final int roomNo;
  final bool isAvailable;
  final List selectedList;
  const Room(
      {super.key,
      required this.selectedList,
      required this.roomNo,
      required this.isAvailable});

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  bool isSelected = false;
  Color fillColor = Colors.transparent;

  Future<bool> isAvailableCheck() async {
    final collection = FirebaseFirestore.instance.collection('vishwakarma');
    final doc = collection.doc(widget.roomNo.toString());
    final data = await doc.get();
    return data.data()!['isAvailable'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: isAvailableCheck(),
        builder: (context, snapshot) {
          if(snapshot.data==false){
            widget.selectedList.remove(widget.roomNo);
          }
          return GestureDetector(
            onTap: () {
              
              if (widget.selectedList.length > 4 &&
                  fillColor == Colors.transparent) {
                showDialog(
                  context: context,
                  builder: ((context) => const AlertDialog(
                        backgroundColor: Colors.grey,
                        content: Text("You can only select upto 5 rooms"),
                      )),
                );
                return;
              }
              setState(() {
                if (isSelected && snapshot.data == true) {
                  isSelected = false;
                  widget.selectedList.remove(widget.roomNo);
                  fillColor = Colors.transparent;
                } else if (snapshot.data == true) {
                  isSelected = true;
                  widget.selectedList.add(widget.roomNo);
                  fillColor = MyColors.buttonBackground;
                } else {
                  fillColor = Colors.grey;
                  widget.selectedList.remove(widget.roomNo);
                  isSelected = false;
                }
              });
              print("After " + snapshot.data.toString());

              print(widget.selectedList);
            },
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: MyColors.buttonTextColor),
                    borderRadius: BorderRadius.circular(2),
                    color: snapshot.data == true ? fillColor : Colors.grey),
                height: 22,
                width: 22,
                child: Center(
                    child: Text(
                  widget.roomNo.toString(),
                  style: const TextStyle(fontSize: 10),
                )),
              ),
            ),
          );
        });
  }
}
