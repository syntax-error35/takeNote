import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/categoryList.dart';

class NoteDropdownButton extends StatefulWidget {
  String category;
  BuildContext ctx;
  List categoryList;
  Function returnCategory;
  // Function(String)? setCategory;
  NoteDropdownButton(
      this.category,
    this.ctx,
    this.categoryList,
    this.returnCategory,
  );

  @override
  State<NoteDropdownButton> createState() => _NoteDropdownButtonState();
}

class _NoteDropdownButtonState extends State<NoteDropdownButton> {
  final _formKey2 = GlobalKey<FormState>();
  String? categoryName;
  List<DropdownMenuItem> categoryList = [];
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    categoryList = Provider.of<Category>(context).categoryList;
  }
  Future showLoadingDialog() {
    return showDialog(
      context: widget.ctx,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          title: const Text('Add Category here'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey2,
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'category',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  onSaved: (value) {
                    categoryName = value!;
                    print(categoryName);
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: () {
                  _formKey2.currentState?.save();
                  Provider.of<Category>(context, listen: false)
                      .addCategoryItem(categoryName!);
                  widget.categoryList.add(categoryName.toString());
                  //widget.saveNote();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Add',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {


    return DropdownButtonFormField(
      //value: Text('CATEGORY'),
      borderRadius: BorderRadius.circular(15),
      dropdownColor: Colors.purple,
      hint:  Text(widget.category.isEmpty ? 'Select Category' : widget.category,
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      items: categoryList,
      onChanged: (value) {
        if (value.toString() == 'add') {
          showLoadingDialog();
        } else {
          String category = value!.toString();
          widget.returnCategory(category);
          // if (widget.setCategory != null) {
          //   widget.setCategory!(value!.toString());
          // }
        }
      },
    );
  }
}
