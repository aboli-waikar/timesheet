import 'package:flutter/material.dart';

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {

  List<String> toDoList;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('Diary'),
      trailing: IconButton(icon: Icon(Icons.add), onPressed: addToDoList(),),
      children: [
        ListView.builder(
            itemCount: toDoList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(toDoList[index]),
                trailing: IconButton(icon: Icon(Icons.delete), onPressed: deleteToDoList(),),
                onTap: editToDoList(),
              );
            },
        )
      ],);
  }

  addToDoList() {
  }

  deleteToDoList() {}

  editToDoList() {}
}
