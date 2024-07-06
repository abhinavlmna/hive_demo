import 'package:flutter/material.dart';
import 'package:hive_demo/models/todo_model.dart';
import 'package:hive_demo/service/todo_service.dart';

class Todohome extends StatefulWidget {
  const Todohome({super.key});

  @override
  State<Todohome> createState() => _TodohomeState();
}

class _TodohomeState extends State<Todohome> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final TodoService _todoService = TodoService();
  List<Todo> _todos = [];

  Future<void> _loadTodos() async {
    _todos = await _todoService.getTodos();
    setState(() {});
  }

  @override
  void initState() {
    _loadTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ToDo List',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 3, right: 3),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: _todos.isEmpty
              ? Center(
                  child: Text(
                    'Click the button to add data',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todo = _todos[index];
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        tileColor: const Color.fromARGB(255, 196, 214, 175),
                        onTap: () {
                          _showEditDialogue(context, index, todo);
                        },
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 225, 204, 142),
                          child: Text('${index + 1}'),
                        ),
                        title: Text('${todo.title}'),
                        subtitle: Text('${todo.description}'),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              Checkbox(
                                  value: todo.completed,
                                  onChanged: (value) {
                                    setState(() {
                                      todo.completed = value!;
                                      _todoService.updateTodo(index, todo);
                                    });
                                  }),
                              IconButton(
                                  onPressed: () {
                                    _todoService.deleteTodo(index);
                                    _loadTodos();
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialogue();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialogue() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add New ToDo'),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'title'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'description'),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            final newTodo = Todo(
                                title: _titleController.text,
                                completed: false,
                                createdAt: DateTime.now(),
                                description: _descriptionController.text);
                            await _todoService.addTodo(newTodo);
                            _titleController.clear();
                            _descriptionController.clear();
                            Navigator.pop(context);
                            _loadTodos();
                          },
                          child: Text('Add')),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showEditDialogue(
      BuildContext context, int index, Todo todo) async {
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Edit ToDo'),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'title'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'description'),
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                    SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          todo.title = _titleController.text;
                          todo.description = _descriptionController.text;
                          todo.createdAt = DateTime.now();
                          if (todo.completed == false) {
                            (todo.completed = true);
                          }
                          await _todoService.updateTodo(index, todo);
                          _titleController.clear();
                          _descriptionController.clear();
                          Navigator.pop(context);
                          _loadTodos();
                        },
                        child: Text('Update')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
