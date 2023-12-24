import 'package:to_do_app/controllers/AlertDialogController.dart';
import 'package:to_do_app/controllers/TodoController.dart';
import 'package:to_do_app/models/enums/CRUD.dart';
import 'package:to_do_app/views/ManageToDoView/ManageToDoView.dart';
import 'package:to_do_app/views/ToDoListView/ToDoListView.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // custom controller
  final TodoController todoController = TodoController();
  final AlertDialogController alertDialogController = AlertDialogController();

  // flutter built-in controller
  final TextEditingController tTextController = TextEditingController();
  final TextEditingController dTextController = TextEditingController();
  final PageController pageController = PageController();
  int currentPageIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Todo App'),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            FocusScope.of(context).unfocus();
            currentPageIndex = index;
          });
        },
        children: [
          // Pg 1 - Todo List
          ToDoListView(
            todoController: todoController,
            alertDialogController: alertDialogController,
            tTextController: tTextController,
            dTextController: dTextController,
            pageController: pageController,
          ),
          //Pg 2 - Add Todo
          ManageToDoView(
            todoController: todoController,
            alertDialogController: alertDialogController,
            tTextController: tTextController,
            dTextController: dTextController,
            pageController: pageController,
            crud: CRUD.C,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (index) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todo List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Todo',
          ),
        ],
      ),
    );
  }
}