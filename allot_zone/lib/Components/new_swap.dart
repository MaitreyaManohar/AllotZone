import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../Colors.dart';

class NewSwap extends StatefulWidget {
  const NewSwap({super.key});

  @override
  State<NewSwap> createState() => _NewSwapState();
}

class _NewSwapState extends State<NewSwap> {
  Color textFieldColor = MyColors.textFieldBorder;
  bool _roomCheck = false;
  int room_no = 100;

  void loading(BuildContext context) {
    //Loading Progress indicator
    showDialog(
        context: context,
        builder: ((context) => const Center(
              child: CircularProgressIndicator(),
            )));
  }

  void message(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: Text(message),
              backgroundColor: Colors.grey,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Enter a room to swap with"),
        ),
        SizedBox(
          width: 90,
          child: TextField(
            onChanged: ((a) {
              int value;
              a.isEmpty ? value = -1 : value = int.parse(a);

              if ((value > 499 || value < 100)) {
                _roomCheck = false;
                setState(() {
                  textFieldColor = Colors.red;
                });
              } else {
                _roomCheck = true;
                room_no = value;
                setState(() {
                  textFieldColor = MyColors.textFieldBorder;
                });
              }
            }),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'\d')),
              FilteringTextInputFormatter.digitsOnly
            ],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: "000",
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: textFieldColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                    color: textFieldColor,
                  ),
                ),
                labelStyle: TextStyle(color: MyColors.textColor)),
          ),
        ),
        TextButton(
          style:
              TextButton.styleFrom(backgroundColor: MyColors.buttonBackground),
          onPressed: () async {
            if (!_roomCheck) {
              message(context, "Enter a valid room number");
            } else {
              final roomToSwapDoc = FirebaseFirestore.instance
                  .collection('vishwakarma')
                  .doc(room_no.toString());
              loading(context);
              final roomToSwapData = await roomToSwapDoc.get();
              Navigator.of(context).pop();
              if (roomToSwapData.data()!['isAvailable']) {
                message(context, "Room $room_no has not been occupied");
              } else {
                final List residents = roomToSwapData.data()!['residents'];
                final requestSwapDoc1 = FirebaseFirestore.instance
                    .collection('users')
                    .doc(residents[0]);
                final requestSwapDoc2 = FirebaseFirestore.instance
                    .collection('users')
                    .doc(residents[1]);

                await requestSwapDoc1.set(
                  {
                    'swaprequests': {
                      '$room_no': residents,
                    }
                  },
                  SetOptions(merge: true)
                );
                await requestSwapDoc2.set(
                  {
                    'swaprequests': {
                      '$room_no': residents,
                    }
                  },
                  SetOptions(merge: true)
                ); 
              }
            }
          },
          child: Text(
            'Swap',
            style: TextStyle(color: MyColors.buttonTextColor),
          ),
        ),
      ],
    );
  }
}
