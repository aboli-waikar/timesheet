import 'package:flutter/material.dart';

class Expenses extends StatelessWidget {
  static String routename = '/Expenses';
  Expenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //toolbarHeight: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.red, Colors.orangeAccent])),
          ),
        ),
        body: ListView(children: [
          Container(),

        ]

        ));
  }
}