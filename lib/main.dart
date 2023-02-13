import 'package:flutter/material.dart';
import 'package:note_app/provider/categoryList.dart';
import 'package:note_app/screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_app/screens/categories_screen.dart';
import 'package:note_app/screens/folder_item_screen.dart';
import 'package:note_app/screens/intro_screen.dart';
import 'package:note_app/screens/tabs_screen.dart';
import 'package:note_app/screens/trash_screen.dart';
import 'package:note_app/screens/welcome_screen.dart';
import 'package:note_app/widgets/note/create_note.dart';
import 'package:note_app/widgets/note/update_note.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (ctx) => Category(),
      child: const NoteApp(),
    ),
  );
}

class NoteApp extends StatelessWidget {
  const NoteApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //primaryTextTheme: ,
        primaryColor: const Color(
          0xffa03cae,
        ),
        primarySwatch: Colors.purple,
        canvasColor: const Color.fromRGBO(38, 37, 37, 0.8),
        //bottomAppBarColor: Colors.transparent,
        //   hintColor:  const Color(
        //   0xffa03cae,
        // ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.purple,
            ),
      ),
      //  home: AuthScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => IntroScreen(),
        AuthScreen.routeName: (_) => const AuthScreen(),
        CreateNote.routeName: (_) => CreateNote(),
        TabsScreen.routeName: (_) => TabsScreen(0),
        TrashScreen.routeName: (_) => TrashScreen(),
        UpdateNote.routeName: (_) => UpdateNote(),
        CategoriesScreen.routeName: (_) => const CategoriesScreen(),
        FolderItemScreen.routeName: (_) => FolderItemScreen(),
        WelcomeScreen.routeName: (_) => WelcomeScreen(),
      },
    );
  }
}
