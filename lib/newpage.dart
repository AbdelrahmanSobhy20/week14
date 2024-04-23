import 'package:flutter/material.dart';
import 'package:to_do_application/todoprovider.dart';
import 'new todo.dart';

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  List<Todo> todolist = [];
  bool todoIsChecked = false;
  TextEditingController titlesOfTasks = TextEditingController();
  TextEditingController urlOfTasks = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titlesOfTasks.dispose();
    urlOfTasks.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Add Task'),
                content: Container(
                  height: 200,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titlesOfTasks,
                        decoration: const InputDecoration(
                            hintText: "Task Title",
                            hintStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      TextFormField(
                        controller: urlOfTasks,
                        decoration: const InputDecoration(
                            hintText: "Task URL",
                            hintStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Add' , style: TextStyle(
                      fontSize: 20
                    ),),
                    onPressed: () {
                      if (titlesOfTasks.text != "" && urlOfTasks.text != "") {
                        TodoProvider.instance.insertTodo(Todo(
                            name: titlesOfTasks.text,
                            url: urlOfTasks.text,
                            isChecked: false));
                      }

                      setState(() {

                      });
                      Navigator.of(context).pop();
                      titlesOfTasks.clear();
                      urlOfTasks.clear();
                      // Dismiss alert dialog
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (val) {
              TodoProvider.instance.deleteAllList();
              setState(() {});
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 0,
                child: Text("Delete All"),
              )
            ],
          )
        ],
        backgroundColor: Colors.blue,
        title: const Text(
          "Tasker",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Todo>>(
                future: TodoProvider.instance.getAllTodo(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.hasData) {
                    todolist = snapshot.data!;
                    return todolist.isEmpty? const Center(child: Text("No Items yet" , style: TextStyle(
                        fontSize: 30,
                        color: Colors.black
                    ),),) :ListView.builder(
                        itemCount: todolist.length,
                        itemBuilder: (context, index) {
                          Todo todo = todolist[index];
                          return ListTile(
                            title: Text(
                              todo.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              todo.url,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            leading: Transform.scale(
                              scale: 2,
                              child: Checkbox(
                                shape: const CircleBorder(),
                                value: todo.isChecked,
                                onChanged: (val) async {
                                  todolist[index].isChecked = val!;
                                  await TodoProvider.instance
                                      .updateTodo(todolist[index]);
                                  setState(() {});
                                },
                              ),
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  if (todo.id != null) {
                                    await TodoProvider.instance
                                        .deleteTodo(todo.id!);
                                  }
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 40,
                                )),
                          );
                        });
                  }
                  return const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
