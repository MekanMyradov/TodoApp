import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/screen/home_screen.dart';
import 'package:to_do_app/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  var todoTitleController = TextEditingController();
  var todoDescriptionController = TextEditingController();
  var todoDateController = TextEditingController();

  var _selectedValue;
  //var _categories = <DropdownMenuItem>[];
  var _categories = List<DropdownMenuItem>.empty(growable: true);


  @override
  void initState(){
    super.initState();
    _listCategories();
  }

  DateTime _dateTime = DateTime.now();

  _pickDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(context: context, initialDate: _dateTime, firstDate: DateTime(1922), lastDate: DateTime(2122));

    if(_pickedDate != null){
      setState(() {
        _dateTime = _pickedDate;
        todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  _listCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
            child: Text(category['name']),
            value: category['name'],
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: todoTitleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Write Todo Title'
              ),
            ),
            TextField(
              controller: todoDescriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Write Todo Description'
              ),
            ),
            TextField(
              controller: todoDateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a Date',
                prefixIcon: InkWell(
                  onTap: () {
                    _pickDate(context);
                  },
                  child: Icon(Icons.calendar_today),
                )
              ),
            ),
            DropdownButtonFormField(
                items: _categories,
                value: _selectedValue,
                hint: Text('Category'),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                }),
            SizedBox(height: 20,),
            RaisedButton(onPressed: () async {
              var todo = Todo();

              todo.title = todoTitleController.text;
              todo.description = todoDescriptionController.text;
              todo.category = _selectedValue.toString();
              todo.todoDate = todoDateController.text;

              var _todoService = TodoService();
              var result = await _todoService.saveTodo(todo);
              //print(result);
              if(result > 0){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    HomeScreen()), (Route<dynamic> route) => false);
              }
            },
              color: Colors.blue,
              child: Text('Save', style: TextStyle(color: Colors.white),),
            )
          ],
        ),
      ),
    );
  }
}
