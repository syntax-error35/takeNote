import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/provider/categoryList.dart';
import 'package:note_app/widgets/category/category_item.dart';
import 'package:note_app/widgets/note/grid_item.dart';
import 'package:provider/provider.dart';

class CategoriesGrid extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  void getCollectionReference() async {
    //var collectionDocSnapshot1 =  snapshots();
    var collectionDocSnapShot2 =
        FirebaseFirestore.instance.collection('Categories').get();
  }

  @override
  Widget build(BuildContext context) {
   List categoryData = Provider.of<Category>(context).categories;
    return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: CategoryItem(categoryData[index]),
            );
          },
      itemCount: categoryData.length,
          // itemCount: categoryDocs,
        );

  }
}
