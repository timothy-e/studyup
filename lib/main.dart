import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StudySessions());
  }
}

class StudySessionsState extends State<StudySessions> {

  final List<String> studyGroups = <String>['A', 'B', 'C', 'D', 'B', 'C', 'D'
  , 'B', 'C', 'D', 'B', 'C', 'D', 'B', 'C', 'D'];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StudyUp!'), actions: <Widget>[
        IconButton(
          icon: Icon(const IconData(0xe145, fontFamily: 'MaterialIcons')),
          onPressed: null,
        ),
        IconButton(
          icon: Icon(const IconData(0xe7fd, fontFamily: 'MaterialIcons')),
          onPressed: null,
        ),
        IconButton(
            icon: Icon(const IconData(0xe152, fontFamily: 'MaterialIcons')),
            onPressed: null)
      ]),
      body: _buildGroups(),
    );
  }

  Widget _buildGroups() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int index) {
          if (index < studyGroups.length) {
            return _buildRow(studyGroups[index]);
          }
        });
  }

  Widget _buildRow(String studyGroup) {
    return new ListTile(
      title: new Text(
        studyGroup,
        style: _biggerFont,
      ),
    );
  }
}

class StudySessions extends StatefulWidget {
  @override
  StudySessionsState createState() => new StudySessionsState();
}
