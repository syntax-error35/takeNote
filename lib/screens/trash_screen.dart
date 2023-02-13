import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/widgets/drawer.dart';
import 'package:note_app/widgets/trash/trash_item.dart';

class TrashScreen extends StatelessWidget {
  static const routeName = 'trash';
  var user = FirebaseAuth.instance.currentUser;
  var deleteNoteId = [];
  bool isEmpty = false;

  getCategoryAndEditData(String docPath, bool restore) async {
    if (!restore) {
      var noteDoc = await FirebaseFirestore.instance
          .collection('trash')
          .doc(docPath)
          .get();
      var noteData = noteDoc.data();
      String category = noteData?['category'];
      print(category);
      print(docPath);

      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(user!.uid)
          .collection(category)
          .doc(docPath)
          .delete();
    } else {
      return;
    }
  }

  void removeFromTrash(bool restore) {
    deleteNoteId.forEach((element) {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        await transaction.delete(element);
      });
      getCategoryAndEditData(element.id, restore);
    });
    print(deleteNoteId);
    //deleteNoteId = [];
  }

  void restoreValues() {
    deleteNoteId.forEach(
      (element) async {
        var noteDoc = await FirebaseFirestore.instance
            .collection('trash')
            .doc(element.id)
            .get();
        var noteData = noteDoc.data();
        if (noteData != null) {
          await FirebaseFirestore.instance
              .collection('notes')
              .doc(element.id)
              .set(noteData);
        }
      },
    );
    removeFromTrash(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                content: const Text(
                  'Would you like to restore these items?',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      restoreValues();
                      Navigator.of(ctx).pop(true);
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //restoreValues,
            child: const Icon(
              Icons.restore,
            ),
          ),
          const SizedBox(
            width: 220,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                content: const Text(
                  'Would you like to permanently delete these item?',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      removeFromTrash(false);
                      Navigator.of(ctx).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //removeFromTrash(false),
            child: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Trash'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('trash')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, trashSnapShot) {
          final trashDocs = trashSnapShot.data?.docs;
          if (trashSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          isEmpty = trashDocs?.isEmpty ?? true;
          if (isEmpty) {
            return Center(
              child: //Column(
                  //   children: const [
                  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.delete_outline,
                    size: 70,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'No notes in Trash',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          } else {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> availableNotes =
                trashDocs!
                    .where(
                        (QueryDocumentSnapshot<Map<String, dynamic>> element) =>
                            element.data()['userId'] == user?.uid)
                    .toList();
            if (availableNotes.isNotEmpty) {
              return GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext ctx, index) {
                  return TrashItem(
                    noteRef: availableNotes[index].reference,
                    title: availableNotes[index].data()['title'],
                    noteBody: availableNotes[index].data()['body'],
                    color: availableNotes[index].data()['color'],
                    date: availableNotes[index].data()['createdAt'],
                    noteIdList: deleteNoteId,
                    category: availableNotes[index].data()['category'],
                  );
                },
                itemCount: availableNotes.length,
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete_outline,
                      size: 70,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'No notes in Trash',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
    ;
  }
}
