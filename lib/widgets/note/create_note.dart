import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/widgets/note/dropdownButton.dart';
import 'package:provider/provider.dart';
import '../../provider/categoryList.dart';

class CreateNote extends StatefulWidget {
  static const routeName = 'create-notes';

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String body = '';
  DateTime date = DateTime.now();
  Color color = Colors.pink;
  var colorList = [
    const Color.fromRGBO(38, 37, 37, 0.8),
    Colors.purple,
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.pink,
    Colors.teal,
  ];
  int colorInt = 0;
  var user = FirebaseAuth.instance.currentUser;
  String userID = FirebaseAuth.instance.currentUser!.uid;
  var categoryController = TextEditingController();
  var categoryClass;
  String categoryName = '';
  List categoryList = [];
  var globalCategory;
  void addCategory(String category) async {
    var currentUserCollection =
        await FirebaseFirestore.instance.collection('Categories').get();
    var currentUserDoc = currentUserCollection.docs.toList();
    if (!currentUserDoc.contains(user!.uid)) {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(user!.uid)
          .set({});
    }
  }

  void addDatatoCategory(String category, var docRef) async {
    categoryList.add(category);
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(user!.uid)
        .collection(category)
        .doc(docRef.id)
        .set(
      {
        'title': title.trim(),
        'body': body.trim(),
        'color': colorInt,
        'createdAt': DateFormat('MMM d, yyyy').format(
          DateTime.now(),
        ),
        'userId': user!.uid,
        'category': category.trim(),
        'timestamp': Timestamp.now(),
      },
    );
  }

  void saveNote(String category) async {
    _formKey.currentState!.save();
    var docRef = await FirebaseFirestore.instance.collection('notes').add(
      {
        'title': title.trim(),
        'body': body.trim(),
        'color': colorInt,
        'createdAt': DateFormat('MMM d, yyyy').format(
          DateTime.now(),
        ),
        'userId': user!.uid,
        'category': category.trim(),
        'timestamp': Timestamp.now(),
      },
    );
    addCategory(category); // adding category
    addDatatoCategory(category, docRef); // adding data to category
  }

  void returnCategory(String category) {
    globalCategory = category;
  }

  Widget buildBottomNavBar() {
    return BottomAppBar(
      color: Colors.transparent,
      child: Container(
        width: 150,
        height: 70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            colorList.length,
            (index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: colorList[index],
                  ),
                  child: InkWell(
                    onTap: () {
                      colorInt = colorList[index].value;
                      setState(
                        () {
                          color = colorList[index];
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    categoryClass = Provider.of<Category>(context).categoryList;
    color = Theme.of(context).canvasColor;
  }

  // save Category file folders
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      bottomNavigationBar: buildBottomNavBar(),
      appBar: AppBar(
        title: const Text("Add a note!"),
        //automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              saveNote(globalCategory);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextFormField(
                    key: const ValueKey('title'),
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                      ),
                      //Theme.of(context).textTheme.headlineMedium,
                    ),
                    onSaved: (value) => title = value!,
                  ),
                  TextFormField(
                    key: const ValueKey('note'),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Note',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 200,
                    onSaved: (value) => body = value!,
                  ),
                  NoteDropdownButton(
                    '',
                    context,
                    categoryList,
                    returnCategory,
                    //setCategory: (String category) {},
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
