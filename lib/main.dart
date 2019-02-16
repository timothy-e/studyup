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
      body: _filterClasses(),
    );
  }

  Widget _filterClasses(){
    return Column(
      children: <Widget>[
        Center(
          child: Text('Filter By Classes')
        ),
        Expanded(
          child: DropdownButton<String>(
            items: <String>['2AA4', '2XB3', '2CO3', '2FA3', '2GA3'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
        ),
      ],
    );
  }

}

class StudySessions extends StatefulWidget{
  @override
  StudySessionsState createState() => new StudySessionsState();
}