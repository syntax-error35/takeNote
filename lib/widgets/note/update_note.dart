import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dropdownButton.dart';

class UpdateNote extends StatefulWidget {
  static const routeName = 'update-note';
   int color = Colors.pinkAccent.value;

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  var title;
  var body;
  var noteRef;
  var noteDoc;
  var noteData;
  var user = FirebaseAuth.instance.currentUser;
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
  List categoryList = [];
  var initValues = {
    'title': '',
    'body': '',
    'createdAt': Timestamp.now(),
    'category': 'Default',
  };
  var globalCategory;
  var prevCategory;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      noteRef = ModalRoute.of(context)?.settings.arguments;
      noteDoc = await FirebaseFirestore.instance
          .collection('notes')
          .doc(noteRef.id)
          .get();
      noteData =  noteDoc.data();
      setState  (  ()  {
        initValues = {
          'title': noteData['title'],
          'body': noteData['body'],
          'createdAt': Timestamp.now(),
          'category': noteData['category'],
          'color': noteData['color'],
        };
        widget.color = noteData['color'];
       // print(widget.color);
        prevCategory = noteData['category'].toString();
      });
     // print(prevCategory);
    });
  }

  final _formKey = GlobalKey<FormState>();

  Future<bool> addCategory(String category) async {
    // adding newly created category
    var currentUserCollection =
        await FirebaseFirestore.instance.collection('Categories').get();
    var currentUserDoc = currentUserCollection.docs.toList();
    if (!currentUserDoc.contains(user!.uid)) {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(user!.uid)
          .set({});
      return true;
    }
    return false;
  }

  void addDataToCategory(String category) async {
    //adding data when new category is created
    categoryList.add(category);
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(user!.uid)
        .collection(category)
        .doc(noteRef.id)
        .set(
      {
        'title': title.trim(),
        'body': body.trim(),
        'color': widget.color,
        'createdAt': DateFormat('MMM d, yyyy').format(
          DateTime.now(),
        ),
        'userId': user!.uid,
        'category': category.trim(),
        'timestamp': Timestamp.now(),
      },
    );
  }

  void setDataToCategory(String category) async {
    // updating the data when category unchanged
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(user!.uid)
        .collection(category)
        .doc(noteRef.id)
        .set(
      {
        'title': title.toString().trim(),
        'body': body.toString().trim(),
        'color': widget.color,
        'createdAt': DateFormat('MMM d, yyyy').format(DateTime.now()),
        'userId': user!.uid,
        'category': category,
        'timestamp': Timestamp.now(),
      },
    );
  }

  void removeFromCategory(String prevCategory) async {

    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(user!.uid)
        .collection(prevCategory)
        .doc(noteRef.id)
        .delete();
   print ('Deletion completed');
  }

  void saveNote(String category, String prevCategory) async {
    _formKey.currentState!.save();
    await FirebaseFirestore.instance.collection('notes').doc(noteRef.id).update(
      {
        'title': title,
        'body': body,
        'createdAt': DateFormat('MMM d, yyyy').format(DateTime.now()),
        'userId': user!.uid,
        'category': category,
      },
    );
    bool addData = await addCategory(category);
    if (addData) {
      addDataToCategory(category);
    } else {
      print(prevCategory);
      print(category);
      if (prevCategory == category) {
       // print(prevCategory);
        setDataToCategory(category);
      } else {
       // print(prevCategory);
       // print(category);
        removeFromCategory(prevCategory);
        setDataToCategory(category);
      }
    }
    //Navigator.of(context).pop();
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
                    // colorInt = colorList[index].value;
                      setState(() {
                        widget.color = colorList[index].value;
                      });
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
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: buildBottomNavBar(),
     backgroundColor: Color(widget.color),
      appBar: AppBar(
        title: const Text("Update Note"),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              saveNote(globalCategory, prevCategory);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    key: UniqueKey(),
                    initialValue: initValues['title'].toString(),
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(fontSize: 25, color: Colors.grey)
                        //Theme.of(context).textTheme.headlineMedium,
                        ),
                    onSaved: (value) => title = value!,
                  ),
                  TextFormField(
                    key: UniqueKey(),
                    initialValue: initValues['body'].toString(),
                    style: const TextStyle(color: Colors.white),
                    //key: const ValueKey('note'),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Note',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 200,
                    onSaved: (value) => body = value!,
                  ),
                  NoteDropdownButton(
                    initValues['category'] as String,
                    context,
                    categoryList,
                    returnCategory,
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
