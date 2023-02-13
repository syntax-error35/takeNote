import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/CustomTransition/custom_route.dart';
import 'package:note_app/CustomTransition/inOut.dart';
import 'package:note_app/CustomTransition/rightToLeft.dart';
import 'package:note_app/screens/auth_screen.dart';
import 'package:note_app/screens/tabs_screen.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = 'intro-screen';
  //const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.cyan, Colors.white]) ),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('asset/intro_bg.webp'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'asset/notes.json',
              width: 400,
              height: 300,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'TakeNote',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'App to take notes to keep you organised',
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
                    CustomRoute(builder: (ctx) => AuthScreen()));
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
      ),
    );
  }
}
