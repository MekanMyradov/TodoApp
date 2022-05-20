import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/services/todo_service.dart';

class TodosByCategory extends StatefulWidget {

  final String category;
  TodosByCategory({required this.category});

  @override
  State<TodosByCategory> createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {

  List<Todo> _todoList = List<Todo>.empty(growable: true);
  TodoService _todoService = TodoService();

  @override
  void initState(){
    super.initState();
    getTodosByCategories();
  }

  getTodosByCategories() async {
    var todos = await _todoService.readTodosByCategory(this.widget.category);
    todos.forEach((todo) {
      setState(() {
        var todoModel = Todo();
        todoModel.title = todo['title'];
        todoModel.description = todo['description'];
        todoModel.todoDate = todo['todoDate'];
        
        _todoList.add(todoModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos by Category'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: (context, index){
                    return Card(
                      elevation: 8,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_todoList[index].title ?? 'No Title')
                          ],
                        ),
                        subtitle: Text(_todoList[index].description ?? 'No Description'),
                        trailing: Text(_todoList[index].todoDate ?? 'No Date'),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
