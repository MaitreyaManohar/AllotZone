import 'package:allot_zone/after_selection.dart';
import 'package:allot_zone/room_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Colors.dart';

class FirstPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  FirstPage({super.key});

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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "Welcome To \n Allot Zone!",
                style: TextStyle(
                    fontFamily: 'Monsterrat',
                    fontSize: 39,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: MyColors.textFieldBorder,
                            )),
                        labelText: "Enter email",
                        labelStyle: TextStyle(color: MyColors.textColor)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(
                              color: MyColors.textFieldBorder,
                            )),
                        labelText: "Enter password",
                        labelStyle: TextStyle(color: MyColors.textColor)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    //Login or Signup Button
                    onPressed: () async {
                      //Checking if the given email is valid
                      if (!EmailValidator.validate(_emailController.text)) {
                        showDialog(
                            context: context,
                            builder: ((context) => const AlertDialog(
                                  content: Text("Please enter a valid email"),
                                )));
                        return;
                      }

                      //Loading Progress indicator
                      showDialog(
                          context: context,
                          builder: ((context) => const Center(
                                child: CircularProgressIndicator(),
                              )));

                      try {
                        //Signing in with given email and password
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);

                        Navigator.of(context)
                            .pop(); //Popping progress indicator after logging in

                        loading(context);
                        final doc = FirebaseFirestore.instance
                            .collection('users')
                            .doc(_emailController.text);
                        final data = await doc.get();
                        Navigator.of(context).pop();
                        if (data.data() != null &&
                            data.data()!['roomChosen'] != null) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => AfterSelection(
                                  roomNo: data.data()!['roomChosen']))));
                          return;
                        }

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const RoomSelection())));
                        return;
                      } on FirebaseAuthException catch (e) {
                        //Popping the circular progress indicator
                        Navigator.of(context).pop();
                        if (e.code == 'user-not-found') {
                          //Handling the possibility of a new account creation
                          showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                content: const Text(
                                    "You are creating a new account, do you want to create an account with the password that you entered?"),
                                backgroundColor: Colors.grey,
                                actions: [
                                  //Yes button in the dialogue
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            MyColors.buttonBackground),
                                    onPressed: () async {
                                      //Loading Progress indicator
                                      // showDialog(
                                      //     context: context,
                                      //     builder: ((context) => const Center(
                                      //           child:
                                      //               CircularProgressIndicator(),
                                      //         )));

                                      try {
                                        loading(context);
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text);
                                        //Popping progress indicator after logging in
                                        Navigator.pop(context);

                                        loading(context);
                                        final doc = FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(_emailController.text);
                                        final data = await doc.get();
                                        Navigator.pop(context);

                                        if (data.data() != null &&
                                            data.data()!['roomChosen'] !=
                                                null) {
                                          Navigator.pop(
                                              context); //Popping the creating account alert box
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      AfterSelection(
                                                          roomNo: data.data()![
                                                              'roomChosen']))));
                                          return;
                                        }
                                        Navigator.pop(
                                            context); //Popping the creating account alert box
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const RoomSelection())));
                                        return;
                                      } on FirebaseAuthException catch (e) {
                                        showDialog(
                                            context: context,
                                            builder: ((context) => AlertDialog(
                                                  content: Text(
                                                      e.message.toString()),
                                                )));
                                      }
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: MyColors.buttonTextColor),
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            MyColors.buttonBackground),
                                    onPressed: (() =>
                                        Navigator.of(context).pop()),
                                    child: Text(
                                      'No',
                                      style: TextStyle(
                                          color: MyColors.buttonTextColor),
                                    ),
                                  )
                                ],
                              );
                            }),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: ((context) => AlertDialog(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.grey,
                                  )));
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          MyColors.buttonBackground),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: Text(
                      "SignUp or Login",
                      style: TextStyle(
                        color: MyColors.buttonTextColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
