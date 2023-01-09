import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Colors.dart';

class FirstPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  FirstPage({super.key});

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
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);
                      } on FirebaseAuthException catch (e) {
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
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            MyColors.buttonBackground),
                                    onPressed: () async {
                                      try {
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text);
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
