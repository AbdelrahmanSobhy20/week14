import 'package:to_do_application/todoprovider.dart';

class Todo {
  int? id;
  late String name;
  late int date;
  late bool isChecked;

  Todo({
    this.id,
    required this.name,
    required this.date,
    required this.isChecked,
  });

  Todo.fromMap(Map<String, dynamic> map) {
    if (map[columnId] != null) id = map[columnId];
    name = map[columnName];
    date = map[columnDate];
    isChecked = map[columnIsChecked] == 0 ? false : true;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (id != null) map[columnId] = id;
    map[columnName] = name;
    map[columnDate] = date;
    map[columnIsChecked] = isChecked ? 1 : 0;
    return map;
  }
}
