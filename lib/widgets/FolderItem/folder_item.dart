import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_app/widgets/note/update_note.dart';

class FolderItem extends StatefulWidget {
  var noteRef;
  final String title;
  final String noteBody;
  var color;
  final String date;
  final String category;

  FolderItem({
    required this.noteRef,
    required this.title,
    required this.noteBody,
    required this.color,
    required this.date,
    required this.category,
  });

  @override
  State<FolderItem> createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  void removeNoteData() async {
    await FirebaseFirestore.instance
        .runTransaction((Transaction transaction) async {
      await transaction.delete(widget.noteRef);
    });
  }

  void addTrashData() async {
    final trashDoc = await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.noteRef.id)
        .get(); // getting the doc by id
    final trashData = trashDoc.data();
    await FirebaseFirestore.instance
        .collection('trash')
        .doc(widget.noteRef.id)
        .set(trashData!);
  }

  @override
  Widget build(BuildContext context) {
    int colorInt = widget.color;
    return Dismissible(
      key: ValueKey(widget.noteRef),
      background: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).canvasColor,
          ),
          alignment: Alignment.centerRight,
          //padding: const EdgeInsets.only(right: 20),

          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Do you want add this note to Trash?',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('Note added to trash'),
                    ),
                  );
                  addTrashData(); //add doc to trash
                  removeNoteData(); //delete doc

                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
            //a
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.category),
                Text(widget.date),
              ],
            ),
          ),
          child: InkWell(
            splashColor: Colors.pinkAccent,
            //onLongPress: ,
            onTap: () => Navigator.of(context)
                .pushNamed(UpdateNote.routeName, arguments: widget.noteRef),
            child: Container(
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 500),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(colorInt).withOpacity(0.7),
                    Color(colorInt),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                //borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.noteBody,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                    // Text(noteBody),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
