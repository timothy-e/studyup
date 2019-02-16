import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudySessions()
    );
  }
}

class StudySessionsState extends State<StudySessions>{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('StudyUp!'),
        actions: <Widget>[
          IconButton(
            icon: Icon(const IconData(0xe145, fontFamily: 'MaterialIcons')),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(const IconData(0xe7fd, fontFamily: 'MaterialIcons')),
            onPressed: null,
          )
        ]
      ),
    );
  }
}

class StudySessions extends StatefulWidget{
  @override
  StudySessionsState createState() => new StudySessionsState();
}