import 'package:allot_zone/Colors.dart';
import 'package:allot_zone/Components/side_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SelectionRequest extends StatelessWidget {
  const SelectionRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const SideBar(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'AllotZone',
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.email)
              .get(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!['requests'].length,
                  itemBuilder: ((context, index) {
                    String sender =
                        snapshot.data!['requests'].keys.toList()[index];
                    int room = snapshot.data!['requests'][sender];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        minVerticalPadding: 10,
                        tileColor: MyColors.buttonBackground,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        title: Text(sender),
                        subtitle: Text(room.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                //Yes button
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.check,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.close)),
                          ],
                        ),
                      ),
                    );
                  }));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        ));
  }
}
