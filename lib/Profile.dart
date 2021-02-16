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
            Container(child: Image.asset('images/profile.png', ), height: 150, width: 150,),
          ],
        ),
      ),
    );
  }
}

//child: Image.asset("images/profile.png")