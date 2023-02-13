import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/CustomTransition/bottomtoTop.dart';
import 'package:note_app/CustomTransition/rightToLeft.dart';
import 'package:note_app/screens/auth_screen.dart';
import 'package:note_app/screens/categories_screen.dart';
import 'package:note_app/screens/tabs_screen.dart';
import 'package:note_app/screens/trash_screen.dart';
import 'package:note_app/widgets/auth/fb_logIn.dart';
import 'package:note_app/widgets/auth/google_signIn.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('NoteApp'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.notes,
              color: Colors.blue,
            ),
            title: const Text(
              'Notes',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.folder_copy_sharp,
              color: Colors.greenAccent,
            ),
            title: const Text(
              'Folders',
              style: TextStyle(
                color: Colors.greenAccent,
              ),
            ),
            onTap: () {
              // naviagte user to category screen
              Navigator.of(context).pushReplacement(
                  RightToLeft(pageBuilder: (ctx, ani, _) =>TabsScreen(1))
              );
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            title: const Text(
              'Trash',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () {
              // redirect user to the trash page
              Navigator.of(context).pushReplacement(
                  BottomToTop(pageBuilder: (ctx, ani, _) =>TrashScreen() )
              );
             // Navigator.of(context).pushNamed(TrashScreen.routeName);
              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.purpleAccent,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.purpleAccent,
              ),
            ),
            onTap: () {
              logUserOut();
              signOut();
              FirebaseAuth.instance.signOut();
             // SystemNavigator.pop();
              Navigator.of(context).pushReplacement(
                  RightToLeft(pageBuilder: (ctx, ani, _) =>const AuthScreen() )
              );
             // Navigator.of(context).popAndPushNamed(AuthScreen.routeName);
              //Navigator.of(context).pop();
              // Navigator.of(context).pushReplacementNamed('/'); redirect to authscreen to signin

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              //Provider.of<Auth>(context, listen: false).logout();
              //LOG THE USER OUT
            },
          ),
        ],
      ),
    );
  }
}
