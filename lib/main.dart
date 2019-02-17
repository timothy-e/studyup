/* File which implements the widgets and functionality for the main page of
study sessions. May actually change this and make this file super simple and
put the other info in another file
*/
import 'package:flutter/material.dart';
import 'new-study-session.dart';
import 'profile.dart';
import 'study-session-details.dart';

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

  Widget build(BuildContext context) {
    print('testing 1, 2, 3');
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(const IconData(0xe7fd, fontFamily: 'MaterialIcons')),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
          title: Text('StudyUp!'),
          actions: <Widget>[
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
                icon: Icon(const IconData(0xe152, fontFamily: 'MaterialIcons')),
                onPressed: null)
          ]),
      body: _buildGroups(),
    );
  }

  Widget _buildGroups() {
    return new ListView.separated(
        padding: const EdgeInsets.all(25),
        itemCount: studyGroups.length,
        separatorBuilder: (context, index) => Divider(
              height: 30.0,
              color: Colors.white70,
            ),
        itemBuilder: (BuildContext _context, int index) {
          if (index < studyGroups.length) {
            return _buildRow(studyGroups[index]);
          }
        });
  }

  Widget _buildRow(String studyGroup) {
    return new GestureDetector(
        onTap: () {
          //print("Container clicked");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SessionDetails()));
        },
        child: new Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(30.0),
              color: Colors.brown[100],
            ),
            padding: EdgeInsets.all(28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('Title',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('Course'),
                  ],
                ),
                Column(
                  children: [
                    Text('Time'),
                    SizedBox(height: 10),
                    Text('Building',
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    SizedBox(height: 10),
                    Text('Endorsement',
                        style: TextStyle(color: Colors.yellow[800]))
                  ],
                )
              ],
            )));
  }
}

class StudySessions extends StatefulWidget {
  @override
  StudySessionsState createState() => new StudySessionsState();
}
