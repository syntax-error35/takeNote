import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/widgets/note/grid_item.dart';
import 'package:lottie/lottie.dart';

class NoteGrid extends StatelessWidget {
  bool isTrash;
  bool isEmpty = false;

  var user = FirebaseAuth.instance.currentUser;

  NoteGrid(this.isTrash);

  showEmptyGrid() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
            ),
            child: Lottie.asset(
              'asset/girl_pink.json',
             // width: 500,
              height: 350,
            ),
          ),
          // const SizedBox(height: 8,),
          const Text(
            'No notes',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Create a note and it will show up here',
              style: TextStyle(
                color: Color(
                  0xff967bb6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: isTrash
          ? FirebaseFirestore.instance
              .collection('trash')
              .orderBy('timestamp', descending: true)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('notes')
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (ctx, noteSnapShot) {
        final noteDocs = noteSnapShot.data?.docs;
        if (noteSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        isEmpty = noteDocs?.isEmpty ?? true;
        if (isEmpty) {
          return showEmptyGrid();
        } else {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> availableNotes =
              noteDocs!
                  .where(
                      (QueryDocumentSnapshot<Map<String, dynamic>> element) =>
                          element.data()['userId'] == user?.uid)
                  .toList();
          if (availableNotes.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2.5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext ctx, index) {
                return GridItem(
                  noteRef: availableNotes[index].reference,
                  title: availableNotes[index].data()['title'],
                  noteBody: availableNotes[index].data()['body'],
                  color: availableNotes[index].data()['color'],
                  date: availableNotes[index].data()['createdAt'],
                  category: availableNotes[index].data()['category'],
                  //color: availableNotes[index].data()['color'],
                );
              },
              itemCount: availableNotes.length,
            );
          } else {
            return showEmptyGrid();
          }
        }
      },
    );
  }
}
