/* File which implements the widgets and functionality for the main page of
study sessions. May actually change this and make this file super simple and
put the other info in another file
*/
import 'package:flutter/material.dart';
import 'new-study-session.dart';
import 'profile.dart';

void main() => runApp(MyApp());

class Session {
  String theClass;
  String sessionTitle;
  String theBuilding;
  int groupEndorsement;
  int startTime, endTime;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StudySessions());
  }
}

class StudySessionsState extends State<StudySessions> {
  final List<String> studyGroups = <String>[
    'A',
    'B',
    'C',
    'D',
    'B',
    'C',
    'D',
    'B',
    'C',
    'D',
    'B',
    'C',
    'D',
    'B',
    'C',
    'D'
  ];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('StudyUp!'), actions: <Widget>[
        IconButton(
          icon: Icon(const IconData(0xe145, fontFamily: 'MaterialIcons')),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewStudySession()),
            );
          },
        ),
        IconButton(
          icon: Icon(const IconData(0xe7fd, fontFamily: 'MaterialIcons')),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          },
        ),
        IconButton(
            icon: Icon(const IconData(0xe152, fontFamily: 'MaterialIcons')),
            onPressed: null)
      ]),
      body: _buildGroups(),
    );
  }

  Widget _buildGroups() {
    return new ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: studyGroups.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.white70,
        ),
        itemBuilder: (BuildContext _context, int index) {
          if (index < studyGroups.length) {
            return _buildRow(studyGroups[index]);
          }

        });
  }

  /*
  Widget _buildRow(String studyGroup) {
    return new ListTile(
      title: new Text(
        studyGroup,
        style: _biggerFont,
      ),
    );
  }
  */

  Widget _buildRow(String studyGroup) {
    return new Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(16.0),
          color: Colors.lightBlue[100],
        ),
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text('Title'),
                Text('Course'),
              ],
            ),
            Column(
              children: [
                Text('Time'),
                Text('Building'),
                Text('Endorsement')],
            )
          ],
        ));
  }
}

class StudySessions extends StatefulWidget {
  @override
  StudySessionsState createState() => new StudySessionsState();
}
