import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'new todo.dart';

const String columnId = 'id';
const String columnName = 'name';
const String columnDate = 'date';
const String columnIsChecked = 'isChecked';
const String todoTable = 'todo_table';

class TodoProvider{
late Database db;

static final TodoProvider instance = TodoProvider._internal();
factory TodoProvider(){
  return instance;
}
TodoProvider._internal();

Future open() async {
  db = await openDatabase(join(await getDatabasesPath(), 'todos.db'), version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
create table $todoTable ( 
  $columnId integer primary key autoincrement, 
  $columnName text not null,
  $columnDate integer not null,
  $columnIsChecked integer not null)
''');
      });
}

Future<Todo> insertTodo(Todo todo) async {
  todo.id = await db.insert(todoTable, todo.toMap());
  return todo;
}

Future<List<Todo>> getAllTodo()async{
  List<Map<String , dynamic>> todoMaps = await db.query(todoTable);
  if (todoMaps.isEmpty){
    return [];
  } else{
    List<Todo> todos = [];
    for (var element in todoMaps) {
      todos.add(Todo.fromMap(element));
    }
    return todos;
  }
}

Future<int> deleteTodo(int id) async {
  return await db.delete(todoTable, where: '$columnId = ?', whereArgs: [id]);
}
Future<int> updateTodo(Todo todo) async {
  return await db.update(todoTable, todo.toMap(),
      where: '$columnId = ?', whereArgs: [todo.id]);
}

Future close() async => db.close();
}