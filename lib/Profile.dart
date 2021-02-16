import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TimeSheet"),),
      body: Center(
        child: Column(
          children: [
            Text("Hello"),
            Image.asset("images/profile.png"),
          ],
        ),
      ),
    );
  }
}

//child: Image.asset("images/profile.png")