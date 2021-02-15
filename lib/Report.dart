import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  Report();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TimeSheet"),),
      body: Center(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(child: Text("In Report"), color: Colors.green, height: 200,
              width: MediaQuery.of(context).size.width/2 ),
          Container(child: Text("In Report"), color: Colors.blue, height: 200,
              width: MediaQuery.of(context).size.width/2),
        ],
      )),
    );
  }
}

