import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/widgets/FolderItem/folder_item.dart';

class FolderItemScreen extends StatefulWidget {
  static const routeName = 'folder-item';
  var folderTitle;
  @override
  State<FolderItemScreen> createState() => _FolderItemScreenState();
}

class _FolderItemScreenState extends State<FolderItemScreen> {
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    widget.folderTitle = ModalRoute.of(context)!.settings.arguments as String;
    super.didChangeDependencies();
  }

  // Color getColor(int index) {
  //   List<Color> colors = const [
  //     Colors.red,
  //     Colors.orange,
  //     Colors.amber,
  //     Colors.blue,
  //     Colors.green,
  //     Colors.lightBlue,
  //     Colors.lightGreen,
  //     Colors.pink,
  //     Colors.teal,
  //     Colors.purple,
  //   ];
  //   if ((index + 1) % 10 == 0) {
  //     // print()
  //     return colors[9];
  //   } else if ((index + 1) % 9 == 0) {
  //     // print()
  //     return colors[8];
  //   } else if ((index + 1) % 8 == 0) {
  //     // print()
  //     return colors[7];
  //   } else if ((index + 1) % 7 == 0) {
  //     // print()
  //     return colors[6];
  //   } else if ((index + 1) % 6 == 0) {
  //     // print()
  //     return colors[5];
  //   } else if ((index + 1) % 5 == 0) {
  //     // print()
  //     return colors[4];
  //   } else if ((index + 1) % 4 == 0) {
  //     // print()
  //     return colors[3];
  //   } else if ((index + 1) % 3 == 0) {
  //     // print()
  //     return colors[2];
  //   }
  //   if ((index + 1) % 2 == 0) {
  //     // print()
  //     return colors[1];
  //   }
  //   return colors[0];
  // }

//FolderItemScreen(this.folderTitle);
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderTitle),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Categories')
            .doc(user?.uid)
            .collection(widget.folderTitle)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (ctx, categorySnapshots) {
          final categoryDocs = categorySnapshots.data?.docs.toList();
          if (categorySnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (categoryDocs!.isNotEmpty) {
              return GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2.5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext ctx, index) {
                  return FolderItem(
                    noteRef: categoryDocs[index].reference,
                    title: categoryDocs[index].data()['title'],
                    noteBody: categoryDocs[index].data()['body'],
                    color: categoryDocs[index].data()['color'],
                    date: categoryDocs[index].data()['createdAt'],
                    category: categoryDocs[index].data()['category'],
                    //color: categoryDocs[index].data()['color'],
                  );
                },
                itemCount: categoryDocs.length,
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.folder_outlined,
                      size: 80,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'This Folder is Empty',
                      style: TextStyle(
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
