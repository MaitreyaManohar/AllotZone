import 'package:allot_zone/wing_selection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Colors.dart';

class FirstPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AlertDialog alert = const AlertDialog(
    title: Text("My title"),
    content: Text("This is my message."),
  );

  Future signIn(BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: 
      ((context) => const WingSelection())
      ));
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: ((context) => AlertDialog(
                backgroundColor: Colors.grey,
                title: const Text("Wrong password"),
                content: Text(e.toString()),
              )));
    }

  }

  Future signUp(BuildContext context, String email, String password) async {
    // showDialog(
    //     context: context,
    //     builder: ((context) => const CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: 
      ((context) => const WingSelection())
      ));
    
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'email-already-in-use') {
        signIn(context, email, password);
      } else {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                backgroundColor: Colors.grey,
                title: const Text("Error"),
                content: Text(e.toString()),
              );
            }));
      }
    }

    // Navigator.of(context).pop();
  }

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
                    obscureText: true,
                    controller: _passwordController,
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
                    onPressed: () {
                      signUp(context, _emailController.text,
                          _passwordController.text);
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
