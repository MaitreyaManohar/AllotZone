import 'package:allot_zone/Colors.dart';
import 'package:allot_zone/after_selection.dart';
import 'package:allot_zone/room_select.dart';
import 'package:allot_zone/selection_requests.dart';
import 'package:allot_zone/swap_request.dart';
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

  Future<int> _checkChosenRoom() async {
    try {
      final doc = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email);

      final data = await doc.get();
      if (!data.exists) {
        return 0;
      } else if (data.data()!['roomChosen'] != null) {
        return data.data()!['roomChosen'];
      }
      return 0;
    } on Exception catch (_) {
      return -1;
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
              child: Center(child: Text("Welcome ${FirebaseAuth.instance.currentUser!.email}")),
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError) {
                  return const Text("Loading");
                }
                if (snapshot.hasData && !snapshot.data!.exists) {
                  return ListTile(
                    title: const Text("Room selection"),
                    leading: const Icon(
                      Icons.swap_calls,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: ((context) => const RoomSelection())));
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.done && snapshot.data!.data()!=null) {
                    return ListTile(
                      title: Text((snapshot.data!.data()!['roomChosen'] == null)
                          ? "Room Selection"
                          : "Room selected"),
                      leading: const Icon(
                        Icons.door_front_door,
                        color: Colors.white,
                      ),
                      onTap: () {
                        (snapshot.data!.data()!['roomChosen'] == null)
                            ? Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const RoomSelection())))
                            : Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: ((context) => AfterSelection(
                                        roomNo: snapshot.data!
                                            .data()!['roomChosen']))));
                      },
                    );
                  
                }
                return const Text("loading");
              },
            ),
            FutureBuilder(
                future: _checkChosenRoom(),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.hasError) {
                    return const Text("loading");
                  }

                  if (snapshot.connectionState == ConnectionState.done ||
                      !snapshot.hasData) {
                    if ((snapshot.data!) != 0) {
                      return ListTile(
                        title: const Text("Swap Requests"),
                        leading: const Icon(
                          Icons.swap_calls,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SwapRequest(),
                              ));
                        },
                      );
                    }
                    return ListTile(
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
                    );
                  }

                  return const Text("Loading...");
                })),
          ],
        ));
  }
}
