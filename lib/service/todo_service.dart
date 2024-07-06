import 'package:hive_demo/models/todo_model.dart';
import 'package:hive_flutter/adapters.dart';

class TodoService {
  Box<Todo>? _todoBox;
  Future<void> openBox() async {
    _todoBox = await Hive.openBox('todos');
  }

  Future<void> closeBox() async {
    await _todoBox!.close();
  }

  Future<void> addTodo(Todo todo) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.add(todo);
  }

  Future<List<Todo>> getTodos() async {
    if (_todoBox == null) {
      await openBox();
    }
    return _todoBox!.values.toList();
  }

  Future<void> updateTodo(int index, Todo todo) async {
    if (_todoBox == null) {
      await updateTodo(index, todo);
    }
    return _todoBox!.putAt(index, todo);
  }

  Future<void> deleteTodo(int index) async {
    if (_todoBox == null) {
      await deleteTodo(index);
    }
    return _todoBox!.deleteAt(index);
  }
}
