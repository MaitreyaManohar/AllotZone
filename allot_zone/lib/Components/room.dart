import 'package:allot_zone/Colors.dart';
import 'package:flutter/material.dart';

class Room extends StatefulWidget {
  final int roomNo;
  final bool isAvailable;
  final List selectedList;
  const Room({super.key, required this.selectedList,required this.roomNo, required this.isAvailable});

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  bool isSelected = false;
  Color fillColor = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print(widget.selectedList);
          if(isSelected){
            isSelected=false;
            widget.selectedList.remove(widget.roomNo);
            fillColor = Colors.transparent;
          }
          else{
            isSelected= true;
            widget.selectedList.add(widget.roomNo);
            fillColor = MyColors.buttonBackground;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: MyColors.buttonTextColor),
              borderRadius: BorderRadius.circular(2),
              color: widget.isAvailable ? fillColor: Colors.grey),
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
  }
}
