import 'package:allot_zone/Colors.dart';
import 'package:allot_zone/Components/side_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SelectionRequest extends StatelessWidget {
  const SelectionRequest({super.key});

  void loading(BuildContext context) {
    //Loading Progress indicator
    showDialog(
        context: context,
        builder: ((context) => const Center(
              child: CircularProgressIndicator(),
            )));
  }

  Future _future() async {
    final data = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    if (data.data()!['requests'] == null) {
      return null;
    } else {
      return data;
    }
  }

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
          future: _future(),
          builder: ((context, snapshot) {
            if (snapshot.data == null) {
              return const Center(child: Text("No requests"));
            }
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
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: ((context) => AlertDialog(
                                            backgroundColor: Colors.grey,
                                            content: const Text(
                                                "Confirm that you accept this request"),
                                            actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor: MyColors
                                                        .buttonBackground),
                                                onPressed: () {},
                                                child: Text(
                                                  'Yes',
                                                  style: TextStyle(
                                                      color: MyColors
                                                          .buttonTextColor),
                                                ),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor: MyColors
                                                        .buttonBackground),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      color: MyColors
                                                          .buttonTextColor),
                                                ),
                                              ),
                                            ],
                                          )));
                                },
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
