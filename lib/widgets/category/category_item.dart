import 'package:flutter/material.dart';

import '../../screens/folder_item_screen.dart';

class CategoryItem extends StatelessWidget {
  String categoryTitle;
  CategoryItem(this.categoryTitle);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(categoryTitle),
            ],
          ),
        ),
        child: InkWell(
          splashColor: Colors.pinkAccent,
          //onLongPress: ,
          onTap: () => Navigator.of(context).pushNamed(FolderItemScreen.routeName, arguments: categoryTitle),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purpleAccent.withOpacity(0.7),
                  Colors.purpleAccent,
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.0,
                    ),
                    child: Icon(
                      Icons.folder,
                      size: 75,
                      color: Colors.amber,
                    ),
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
