import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/screens/tabs_screen.dart';

import '../CustomTransition/custom_route.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = 'welcome';
  //const WelcomeScreen({Key? key}) : super(key: key);
  var userId = FirebaseAuth.instance.currentUser?.uid;

  String getUsername(){
    var username;
    var userData;
    Future<void> Username() async {
       userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
       username = userData.data()!['username'].toString();
       print(username);
      return;
    }
    Username();
    return username;
  }

  @override
  Widget build(BuildContext context) {
  String username = getUsername();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'asset/floral.json',
            width: 400,
            height: 300,
          ),
          const SizedBox(
            height: 16,
          ),
           Text(
            'Welcome back, $username!',
            style: const TextStyle(
              color: Colors.lightBlue,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Get your notes, Add, Edit or Delete as you wish.',
            style: TextStyle(
              // color: Colors.lightBlue,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (ctx) => TabsScreen(0))
              );
              //Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
              //  Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
            }, // add animated route transition
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              backgroundColor: const MaterialStatePropertyAll<Color>(
                Colors.lightBlueAccent,
              ),
            ),
            child: const Text(
              'Get Started',
            ),
          ),
        ],
      ),
    );
  }
}
