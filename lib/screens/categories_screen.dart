import 'package:flutter/material.dart';
import 'package:note_app/widgets/category/categories_grid.dart';
class CategoriesScreen extends StatelessWidget {
  static const routeName = 'categories-screen';
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CategoriesGrid();
  }
}
