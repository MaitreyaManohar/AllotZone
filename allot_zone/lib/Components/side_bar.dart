import 'package:allot_zone/Colors.dart';
import 'package:allot_zone/room_select.dart';
import 'package:allot_zone/selection_requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

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

  Future<bool> checkSentRequest(BuildContext context) async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email);

      final data = await doc.get();

      if (data.data() != null) {
        if (data.data()!['sentRequest'] == null) {
          return true;
        } else {
          return false;
        }
      }
      return false;
    } on Exception catch (e) {
      message(context, e.toString());
      return false;
    }
  }

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
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError) {
                  return SizedBox.shrink();
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Document does not exist");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.data()!['sentRequest'] == null) {
                    return ListTile(
                      title: const Text("Room Selection"),
                      leading: const Icon(
                        Icons.door_front_door,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => const RoomSelection())));
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }
                return const Text("loading");
              },
            ),
            ListTile(
              title: const Text("Swap Requests"),
              leading: const Icon(
                Icons.swap_calls,
                color: Colors.white,
              ),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Room Selection Requests"),
              leading: const Icon(
                Icons.arrow_right_alt,
                color: Colors.white,
              ),
              onTap: () {
                if (ModalRoute.of(context)!.settings.name ==
                    '/selection_requests') {
                  Navigator.pop(context);
                }
                Navigator.of(context)
                    .pushReplacementNamed('/selection_requests');
              },
            )
          ],
        ));
  }
}
