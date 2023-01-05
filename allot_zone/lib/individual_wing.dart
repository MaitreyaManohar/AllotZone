import 'package:allot_zone/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WingModel {
  int wingId = 0;
  int wingSize;
  double width = 100, height = 300;
  bool isHorizontal = false;
  bool isSelected = false;
  bool isAvailable=true;
  Color fill = const Color.fromARGB(0, 255, 193, 7);
  WingModel(
      {required this.wingId,
      required this.wingSize,
      required this.isHorizontal}) {
    height = wingSize * 50;
    width = 100;
    if (isSelected) fill = Colors.grey;
    if (isHorizontal) {
      double temp = height;
      height = width;
      width = temp;
    }
  }
  void onTapModel() {
    if (fill != Colors.amber) {
      fill = Colors.amber;
      isSelected = true;
    } else {
      isSelected= false;
      fill = const Color.fromARGB(0, 255, 193, 7);
    }
  }

  set setIsSelected(bool f) {
    isSelected = f;
  }

  double get getHeight {
    return height;
  }

  double get getWidth {
    return width;
  }

  set setFill(Color color) {
    fill = color;
  }
}
