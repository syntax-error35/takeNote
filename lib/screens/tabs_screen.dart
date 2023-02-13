import 'package:flutter/material.dart';
import 'package:note_app/CustomTransition/toptoBottom.dart';
import 'package:note_app/screens/categories_screen.dart';
import 'package:note_app/widgets/drawer.dart';
import 'package:note_app/widgets/note/create_note.dart';
import 'package:note_app/widgets/note/note_grid.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = 'tabs-screen';
int index;
TabsScreen(this.index);
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> with TickerProviderStateMixin {
  late TabController tabController;
  bool pgInit = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      tabController = TabController(length: 2, vsync: this, initialIndex: widget.index);
      tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.removeListener(_handleTabIndex);
    tabController.dispose();
  }

  void _handleTabIndex() {
    // setState(() {
    //   _bottomButtons();
    // });
  }

  Widget _bottomButtons() {
    return  FloatingActionButton(
            shape: const StadiumBorder(),
            onPressed: () =>
                Navigator.of(context).push(
                    TopToBottom(pageBuilder: (ctx, ani, _) => CreateNote() )
                ),
                //Navigator.of(context).pushNamed(CreateNote.routeName),
            backgroundColor: Colors.pinkAccent,
            child: const Icon(
              Icons.note_add_outlined,
              size: 20.0,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('Notes'),
          //backgroundColor: ,
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(
                text: 'All',
                //icon: ,
              ),
              Tab(
                // icon: ,
                text: 'Folders',
              ),
            ],
          ),
        ),
        // backgroundColor: ,
        body: TabBarView(
          controller: tabController,
          children: [
            NoteGrid(false),
            CategoriesScreen(),
          ],
        ),
        floatingActionButton: _bottomButtons(),
      ),
    );
  }
}
