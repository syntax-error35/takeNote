import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  var value;
  List categories = ['Personal', 'Work'];
  List<DropdownMenuItem> categoryList = [
    const DropdownMenuItem(
      value: 'Personal',
      child: Text(
        'Personal',
      ),
    ),
    const DropdownMenuItem(
      value: 'Work',
      child: Text(
        'Work',
      ),
    ),
    const DropdownMenuItem(
      value: 'add',
      child: Text(
        'Add category',
      ),
    )
  ];
  void addCategoryItem(String categoryName) {
    var len = categoryList.length;
    categoryList.insert(
      len - 1,
      DropdownMenuItem(
        value: categoryName.toString(),
        child: Text(
          categoryName.toString(),
        ),
      ),
    );
    categories.add(categoryName.toString());
    notifyListeners();
  }

  buildCategoryList(List category) {
    category.forEach(
      (element) {
        categoryList.insert(
          categoryList.length-1,
          DropdownMenuItem(
            child: Text(element.toString()),
            value: element,
          ),
        );
      },
    );
    //return categoryList;
   //notifyListeners();
  }
  // void loadCategory()async {
  //  var user= FirebaseAuth.instance.currentUser;
  //   var doc = await FirebaseFirestore.instance.collection('Categories').doc(
  //       user!.uid).collection(category).get();
  //   var docList = doc.docs.toList();
  //   for(var i in docList) {
  //     print(i.data().values.toString());
  //   }
  // }

}
