import 'package:flutter/material.dart';

class ToDo extends StatefulWidget {
  //const ToDo({Key key}) : super(key: key);
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  List<String> toDoList = [];

  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 20.0),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text('THINGS TO DO'),

        trailing: IconButton(icon: Icon(Icons.add), onPressed: () {
          showDialog(context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Add To Do Item"),
                  content: SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(controller: textController, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)) ),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(child: Text("Add"), onPressed: () {
                            setState(() {
                              toDoList.add(textController.text);
                            });
                            Navigator.pop(context);
                          }, ),
                          ElevatedButton(child: Text("Cancel"), onPressed: () => Navigator.pop(context), ),
                        ],
                      ),
                    ],),
                  ),
                );
              },);
        },),
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: toDoList.length,
            itemBuilder: (context, index) {
              return ListTile(
                  tileColor: Colors.lime,
                  title: Text(toDoList[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => null,
                  ),
                  onTap: () => null);
            },
          ),
        ],
      ),
    );
  }
}
