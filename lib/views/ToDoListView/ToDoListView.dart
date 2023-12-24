import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/controllers/AlertDialogController.dart';
import 'package:to_do_app/controllers/TodoController.dart';
import 'package:to_do_app/models/Todo.dart';
import 'package:to_do_app/models/enums/CRUD.dart';
import 'package:to_do_app/views/ManageToDoView/ManageToDoView.dart';
import 'package:flutter/material.dart';

class ToDoListView extends StatelessWidget {
  const ToDoListView({
    super.key,
    required this.todoController,
    required this.alertDialogController,
    required this.tTextController,
    required this.dTextController,
    required this.pageController,
  });

  final TodoController todoController;
  final AlertDialogController alertDialogController;
  final TextEditingController tTextController;
  final TextEditingController dTextController;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    bool isSwitching = false;
    return StreamBuilder(
      stream: todoController.getTodos(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        else{
          var todos = snapshot.data!.docs.map((doc){
            var data = doc.data() as Map<String, dynamic>;
            return Todo(
              id: doc.id,
              title: data['title'],
              description: data['description'],
              isCompleted: data['isCompleted'],
              isDescDisplayed: data['isDescDisplayed'],
              timestamp: data['timestamp'],
            );
          }).toList();

          todos.sort((a,b) => (b.timestamp).compareTo(a.timestamp));

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder:(context, index) {
              var todo = todos[index];
              Key tileKey = Key(todo.id);

              return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color:Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0,3))
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        key: tileKey,
                        title: Text(todo.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:[
                            IconButton(
                              color: Colors.green,
                              icon: const Icon(Icons.edit),
                              onPressed: (){
                                tTextController.text = todo.title;
                                dTextController.text = todo.description;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        title: const Text('Flutter To Do App'),
                                        leading: IconButton(
                                          icon: Icon(Icons.arrow_back),
                                          onPressed: (){
                                            dTextController.text = "";
                                            tTextController.text = "";
                                            Navigator.pop(context);
                                          },
                                          ),
                                      ),
                                      body: ManageToDoView(
                                        tTextController: tTextController,
                                        dTextController: dTextController,
                                        todoController: todoController,
                                        alertDialogController: alertDialogController,
                                        pageController: pageController,
                                        crud: CRUD.U,
                                        todo: todo,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              color: Colors.red,
                              icon: const Icon(Icons.delete),
                              onPressed: (){
                                todoController.deleteTodo(todo.id);
                              },
                            ),
                            Checkbox(
                              key: ValueKey(todo.id),
                              value: todo.isCompleted,
                              onChanged: (value){
                                todo.isCompleted = value!;
                                todoController.updateTodo(todo);
                              },
                            ),
                          ],
                        ),
                        onTap: (){
                          if(!isSwitching){
                            isSwitching = true;
                            todo.isDescDisplayed = !todo.isDescDisplayed;
                            todoController.updateTodo(todo);

                            // Add delay before allowing another switch
                            Future.delayed(const Duration(milliseconds: 500),
                              (){
                                isSwitching = false;
                              });
                          }
                        },
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: todo.isDescDisplayed
                        ? Padding(
                          key: ValueKey<bool>(todo.isDescDisplayed),
                          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 98,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                      BorderRadius.circular(20.0),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Description",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                                  child: Text(todo.description),
                                ),
                              ],
                            ),
                          ),
                        )
                        :Container(),
                      ),
                    ],
                  ),
                ),
              );
            }
          );
        }
      }
    );
  }
}
