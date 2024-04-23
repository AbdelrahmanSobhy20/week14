import 'package:to_do_application/todoprovider.dart';

class Todo {
  int? id;
  late String name;
  late String url;
  late bool isChecked;

  Todo({
    this.id,
    required this.name,
    required this.isChecked,
    required this.url,
  });

  Todo.fromMap(Map<String, dynamic> map) {
    if (map[columnId] != null) id = map[columnId];
    name = map[columnName];
    url = map[columnURL];
    isChecked = map[columnIsChecked] == 0 ? false : true;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (id != null) map[columnId] = id;
    map[columnName] = name;
    map[columnURL] = url;
    map[columnIsChecked] = isChecked ? 1 : 0;
    return map;
  }
}
