import 'package:allot_zone/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 0,
        backgroundColor: MyColors.sideBarColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 150,
              color: MyColors.buttonBackground,
            ),
            ListTile(
              title: const Text("Room Selection"),
              leading: const Icon(
                Icons.door_front_door,
                color: Colors.white,
              ),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Swap Requests"),
              leading: const Icon(
                Icons.swap_calls,
                color: Colors.white,
              ),
              onTap: () {
              },
            ),
            ListTile(
              title: const Text("Room Selection Requests"),
              leading: const Icon(
                Icons.arrow_right_alt,
                color: Colors.white,
              ),
              onTap: () {},
            )
          ],
        ));
  }
}
