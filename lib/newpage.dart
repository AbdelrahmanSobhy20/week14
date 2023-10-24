import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime? selectedDate;
  TextEditingController titlesOfTasks = TextEditingController();
  TextEditingController dateOfTasks = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              )),
              builder: ((context) {
                return Container(
                  padding: const EdgeInsets.all(20),
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
                        controller: dateOfTasks,
                        decoration: const InputDecoration(
                            hintText: "Due Date",
                            hintStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () async {
                                selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 30)));
                                if (selectedDate != null) {
                                  String formattedDate =
                                      DateFormat('yyyy/MM/dd')
                                          .format(selectedDate!);
                                  setState(() {
                                    dateOfTasks.text = formattedDate;
                                  });
                                }
                              },
                              icon: const Icon(Icons.calendar_month)),
                          const SizedBox(
                            width: 150,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              TodoProvider.instance.insertTodo(Todo(
                                  name: titlesOfTasks.text,
                                  date: selectedDate!.millisecondsSinceEpoch,
                                  isChecked: false));
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }));
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Tasker",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        elevation: 0,
        leading: const Icon(
          Icons.list,
          size: 40,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: const ListTile(
              title: Text(
                "OCT",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "2023",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              leading: Text(
                "20",
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                "Friday",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
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
                    return ListView.builder(
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
                              DateTime.fromMillisecondsSinceEpoch(todo.date)
                                  .toString(),
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
                  return Center(
                    child: Container(
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
