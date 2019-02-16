import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyUp',
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text('StudyUp!'),
          ),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}

class StudySessionsState extends State<StudySessions>{
  
}

class StudySessions extends StatefulWidget{
  @override
  StudySessionsState createState() => new StudySessionsState();
}