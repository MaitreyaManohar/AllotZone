import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Colors.dart';
import 'login_first_page.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  void message(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: Text(message),
              backgroundColor: Colors.grey,
            )));
  }

  void loading(BuildContext context) {
    //Loading Progress indicator
    showDialog(
        context: context,
        builder: ((context) => const Center(
              child: CircularProgressIndicator(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'AllotZone',
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.transparent),
            onPressed: () async {
              loading(context);
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.popUntil(context, (route) => route.isFirst);

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => FirstPage())));
            },
            child: Text(
              'SignOut',
              style: TextStyle(color: MyColors.buttonTextColor),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('vishwakarma').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              bool isAvailable = snapshot.data!.docs[index]['isAvailable'];
              String roomNo = snapshot.data!.docs[index].reference.id;
              List residents =
                  (snapshot.data!.docs[index].data()['residents'] == null)
                      ? []
                      : snapshot.data!.docs[index].data()['residents'];

              return ListTile(
                style: ListTileStyle.drawer,
                title: (residents.isEmpty)
                    ? Text(roomNo)
                    : Text("$roomNo - ${residents[0]} and ${residents[1]}"),
                tileColor: isAvailable ? Colors.amber : Colors.grey,
                trailing: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: MyColors.buttonBackground),
                  onPressed: () async {
                    final roomDoc = FirebaseFirestore.instance
                        .collection('vishwakarma')
                        .doc(roomNo);

                    if (isAvailable) {
                      await roomDoc
                          .set({'isAvailable': false}, SetOptions(merge: true));
                      return;
                    } else {
                      if (!residents.isEmpty) {
                        final residentDoc1 = FirebaseFirestore.instance
                            .collection('users')
                            .doc(snapshot.data!.docs[index]['residents'][0]);
                        await residentDoc1.set(
                            {'roomChosen': FieldValue.delete()},
                            SetOptions(merge: true));
                        final residentDoc2 = FirebaseFirestore.instance
                            .collection('users')
                            .doc(snapshot.data!.docs[index]['residents'][1]);
                        await residentDoc2.set(
                            {'roomChosen': FieldValue.delete()},
                            SetOptions(merge: true));
                      }
                      await roomDoc
                          .set({'isAvailable': true}, SetOptions(merge: true));
                    }
                  },
                  child: Text(
                    !isAvailable ? 'Vacate' : 'Block',
                    style: TextStyle(color: MyColors.buttonTextColor),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
