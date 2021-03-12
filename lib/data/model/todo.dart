import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Todo {
  final String id;
  String text;
  bool completed;

  Todo({
    String? id,
    required this.text,
    this.completed = false,
  }) : id = id ?? uuid.v4();

  @override
  String toString() => 'Todo(id: $id, text: $text, completed: $completed)';
}
