import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/widgets/auth/fb_logIn.dart';
import 'package:note_app/widgets/auth/google_signIn.dart';

import '../../CustomTransition/leftToRight.dart';
import '../../screens/tabs_screen.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String username,
    String password,
    bool isSignIn,
  ) submitFn;

  AuthForm(this.submitFn, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  var _isSignIn = true;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus(); //removes focus & closes the keyboard
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _isSignIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    cursorColor: const Color(
                      0xffa03cae,
                    ),
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please Enter a valid Email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (!_isSignIn)
                    TextFormField(
                      cursorColor: const Color(
                        0xffa03cae,
                      ),
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please Enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                  if (!_isSignIn)
                    const SizedBox(
                      height: 8,
                    ),
                  TextFormField(
                    cursorColor: const Color(
                      0xffa03cae,
                    ),
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    obscureText: true,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffa03cae),
                        fixedSize: const Size(90, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
                    ),
                  if (!widget.isLoading)
                    const SizedBox(
                      height: 20,
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      UserCredential googleUserCred = await signInWithGoogle();
                      if (googleUserCred != null) {
                        Navigator.of(context).pushReplacement(LeftToRight(
                            pageBuilder: (ctx, ani, _) => TabsScreen(0)));
                      }
                    },
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(color: const Color(0xffa03cae)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  if (!widget.isLoading)
                    const SizedBox(
                      height: 30,
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      final bool isLoggedIn = await logUserIn();
                      if (isLoggedIn) {
                        Navigator.of(context).pushReplacement(LeftToRight(
                            pageBuilder: (ctx, ani, _) => TabsScreen(0)));
                      }
                    },
                    child: Text(
                      'Sign in with Facebook',
                      style: TextStyle(color: const Color(0xffa03cae)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  if (!widget.isLoading)
                    const SizedBox(
                      height: 20,
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      UserCredential googleUserCred = await signInWithGoogle();
                      if (googleUserCred != null) {
                        Navigator.of(context).pushReplacement(LeftToRight(
                            pageBuilder: (ctx, ani, _) => TabsScreen(0)));
                      }
                    },
                    child: Text(
                      'Sign in with Google',
                      style: TextStyle(color: const Color(0xffa03cae)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSignIn = !_isSignIn;
                        });
                      },
                      child: Text(
                        _isSignIn
                            ? 'Create new account'
                            : 'I already have an account',
                        style: TextStyle(
                          color: Color(
                            0xffa03cae,
                          ),
                        ),
                      ),
                    ),
                  if (!widget.isLoading)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        fixedSize: const Size(50, 25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Theme.of(context).canvasColor,
                          title: Lottie.asset(
                            'asset/rocket-launch.json',
                            height: 200,
                          ),
                          content: const Text(
                            'Are you sure you want to Exit?',
                            style: TextStyle(
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('No'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                SystemNavigator.pop();
                                Navigator.of(ctx).pop(true);
                              },
                              child: const Text(
                                'Yes',
                              ),
                            ),
                          ],
                          actionsAlignment: MainAxisAlignment.spaceAround,
                        ),
                      ),
                      //SystemNavigator.pop(),
                      child: const Text(
                        'Exit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
