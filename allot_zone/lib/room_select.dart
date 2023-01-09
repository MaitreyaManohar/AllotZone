import 'package:allot_zone/Colors.dart';
import 'package:allot_zone/Components/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RoomSelection extends StatefulWidget {
  const RoomSelection({super.key});

  @override
  State<RoomSelection> createState() => _RoomSelectionState();
}

class _RoomSelectionState extends State<RoomSelection> {
  final floorList = [1, 2, 3, 4];
  int floorSelected = 1;
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: DropdownButton(
              borderRadius: BorderRadius.circular(10),
              value: floorSelected,
              focusColor: Colors.black,
              dropdownColor: MyColors.appBackground,
              iconEnabledColor: Colors.white,
              onChanged: (e) {
                setState(() {
                  floorSelected = e!;
                });
              },
              items: [
                ...floorList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text("Floor $e"),
                        ))
                    .toList()
              ],
            ),
          ),
          RoomLayout(
            floorSelected: floorSelected,
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                backgroundColor: MyColors.buttonBackground,
                foregroundColor: MyColors.buttonTextColor),
            child: const Text("Confirm"),
          )
        ],
      ),
    );
  }
}

class RoomLayout extends StatelessWidget {
  final floorSelected;
  List<int> selectedList = [];

  RoomLayout({Key? key, required this.floorSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(children: [
          const SizedBox(
            width: 42,
          ),
          ...List.generate(
            10,
            (index) => Room(
              isAvailable: true,
              selectedList: selectedList,
              roomNo: floorSelected * 100 + index + 1,
            ),
          ),
        ]),
        Row(children: [
          const SizedBox(
            width: 42,
          ),
          ...List.generate(
            10,
            (index) => Room(
              selectedList: selectedList,
              isAvailable: true,
              roomNo: floorSelected * 100 + index + 10,
            ),
          ),
        ]),
        Row(
          children: [
            Column(
              children: List.generate(
                10,
                (index) => Row(
                  children: [
                    Room(
                      selectedList: selectedList,
                      isAvailable: true,
                      roomNo: floorSelected * 100 + 20 + 2 * index,
                    ),
                    Room(
                        selectedList: selectedList,
                        roomNo: floorSelected * 100 + 20 + 2 * index + 1,
                        isAvailable: true)
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 22 * 10,
            ),
            Column(
              children: List.generate(
                10,
                (index) => Row(
                  children: [
                    Room(
                      selectedList: selectedList,
                      isAvailable: true,
                      roomNo: floorSelected * 100 + 40 + 2 * index,
                    ),
                    Room(
                        selectedList: selectedList,
                        roomNo: floorSelected * 100 + 40 + 2 * index + 1,
                        isAvailable: true)
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 44,
            ),
            ...List.generate(
              10,
              (index) => Room(
                selectedList: selectedList,
                isAvailable: true,
                roomNo: floorSelected * 100 + 60 + index,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 44,
            ),
            ...List.generate(
              10,
              (index) => Room(
                selectedList: selectedList,
                isAvailable: true,
                roomNo: floorSelected * 100 + 70 + index,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 22 * 12,
            ),
            Column(
              children: List.generate(
                10,
                (index) => Row(
                  children: [
                    Room(
                      selectedList: selectedList,
                      isAvailable: true,
                      roomNo: floorSelected * 100 + 80 + 2 * index,
                    ),
                    Room(
                        selectedList: selectedList,
                        roomNo: floorSelected * 100 + 80 + 2 * index + 1,
                        isAvailable: true)
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
