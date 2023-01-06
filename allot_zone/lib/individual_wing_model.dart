import 'package:allot_zone/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class WingModel {
  int wingId;
  double wingSize=6;
  bool isAvailable = true;
  bool isSelected = false;
  bool isHorizontal;
  Color fill = const Color.fromARGB(0, 255, 193, 7);
  
  WingModel({required this.wingId,required this.wingSize,required this.isHorizontal});

  
  set setFill(Color fill){
    this.fill = fill;
  }
  
  set setIsSelected(bool isSelected){
    this.isSelected = isSelected;
  }

  Map<String, dynamic> toJson() => {
        'wingId': wingId,
        'wingSize': wingSize,
        'isAvailable':isAvailable,
        'isHorizontal':isHorizontal
      };

  static WingModel fromJson(Map<String,dynamic> json){
    WingModel w = WingModel(wingId: json['wingId'],isHorizontal: json['isHorizontal'],wingSize: json['wingSize']);
    if(!w.isAvailable) Colors.grey;
    print("This is happening ${w.isSelected}");
    return w;
  }
}
