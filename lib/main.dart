import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> _todos = [];

  TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _todoController,
              decoration: InputDecoration(
                hintText: 'Add a new task',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return Dismissible(
                  key: Key(todo.id.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      _todos.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${todo.title} dismissed'),
                      ),
                    );
                  },
                  child: CheckboxListTile(
                    title: Text(todo.title),
                    value: todo.completed,
                    onChanged: (value) {
                      setState(() {
                        todo.completed = value!;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add a new task'),
                content: TextField(
                  controller: _todoController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter task name',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text('SAVE'),
                    onPressed: () {
                      setState(() {
                        final todo = Todo(
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: _todoController.text,
                          completed: false,
                        );
                        _todos.add(todo);
                        _todoController.clear();
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Todo {
  int id;
  String title;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });
}
