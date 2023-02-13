import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/CustomTransition/leftToRight.dart';
import 'package:note_app/screens/tabs_screen.dart';
import 'package:note_app/screens/welcome_screen.dart';
import '../CustomTransition/inOut.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = 'auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var msg = 'An error occurred, Please check your credentials.';
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String username,
    String password,
    bool isSignIn,
  ) async {
    UserCredential _authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isSignIn) {
        _authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // signing up users
        _authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          //  'image_url' : url,
        });
      }
      Navigator.of(context).pushReplacement(
          LeftToRight(pageBuilder: (ctx, ani, _) =>TabsScreen(0))
      );
      // Navigator.of(context).pushReplacement(
      //   CustomTransition(pageBuilder: (ctx, ani, _) =>TabsScreen() )
      // );
      //Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
    } on PlatformException catch (err) {
      if (err.message!.isNotEmpty) {
        msg = err.message!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ));
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      msg = err.toString();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset/purple_bg.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: AuthForm(
            _submitAuthForm,
            _isLoading,
          ),
        ),
      ),
    );
  }
}
