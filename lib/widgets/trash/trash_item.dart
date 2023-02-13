import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrashItem extends StatefulWidget {
  var noteRef;
  final String title;
  final String noteBody;
  var color;
  final String date;
  List noteIdList;
  final String category;

  TrashItem({
    required this.noteRef,
    required this.title,
    required this.noteBody,
    required this.color,
    required this.date,
    required this.noteIdList,
    required this.category,
  });

  @override
  State<TrashItem> createState() => _TrashItemState();
}

class _TrashItemState extends State<TrashItem> {
  // void removeNoteData()async{
  //   await FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
  //     transaction.delete(widget.noteRef);
  //   } );
  // }
  //
  // void addTrashData() async {
  //   final trashDoc = await FirebaseFirestore.instance.collection('notes').doc(widget.noteRef.id).get(); // getting the doc by id
  //   final trashData = trashDoc.data();
  //   await FirebaseFirestore.instance.collection('trash').doc(widget.noteRef.id).set(trashData!);
  // }
  var isError = false;

  Color setBorderColor(isError) {
    if (isError) return Colors.red;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    int colorInt = widget.color;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          isError = ! isError;
        });
       if(widget.noteIdList.contains(widget.noteRef)) {
         widget.noteIdList.remove(widget.noteRef);
       }
      else{
        widget.noteIdList.add(widget.noteRef);
       }
       //print(widget.noteIdList);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.category),
                Text(widget.date),
              ],
            ),
          ),
          child: Container(
            constraints: BoxConstraints(minHeight: 100, maxHeight: 500),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 4,
                color: setBorderColor(
                  isError
                ),
              ),
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
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Expanded(
                      child: Text(
                    widget.noteBody,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  )),
                  // Text(noteBody),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
