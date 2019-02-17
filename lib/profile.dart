// File to implement the widgets and functionality for showing user profile

import 'package:flutter/material.dart';

class Profile extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('User Profile')
        ),
      ),
    );
  }
}