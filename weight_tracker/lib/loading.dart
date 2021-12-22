import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 200),
          child: Column(
            children: <Widget>[
              Container(
                child: Text("Loading"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
