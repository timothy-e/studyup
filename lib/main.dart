/* File which implements the widgets and functionality for the main page of
study sessions. May actually change this and make this file super simple and
put the other info in another file
*/
import 'package:flutter/material.dart';
import 'new-study-session.dart';
import 'profile.dart';
import 'study-session-details.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StudySessions());
  }
}

class Session {
  final String title;
  final int id;
  final String start_time;
  final String end_time;
  final String building;
  final String courses;

  Session(
      {this.title, this.id,
      this.start_time,
      this.end_time,
      this.building,
      this.courses});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        title: json['title'],
        id: json['id'],
        start_time: json['start_time'],
        end_time: json['end_time'],
        building: json['building'],
        courses: json['courses']);
  }
}

Future<List<Session>> fetchPost() async {
  http.Response resp = await http.get('http://studyup.appspot.com/getsessions');

  // Decoding the Response Body and putting it in an array
  List l = json.decode(resp.body);
  List<Session> sessions = new List();
  l.forEach((i) {
    sessions.add(new Session.fromJson(i));
    return i;
  });
  /* Testing
  for (int j = 0; j < sessions.length; j++) {
    print(j);
    print(sessions[j]);
  }
  */
  return sessions;
  // Parse through sessions (individual JSON Objects)
  // Pass them into .fromJson
  // Get an array of session objects
  // Return this array of session objects

  /*
  if (resp.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return sessions.fromJson(json.decode(resp.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
  */
}

class StudySessionsState extends State<StudySessions> {
  Future<List<Session>> studyGroups;
  @override
  void initState() {
    super.initState();
    studyGroups = fetchPost();
  }

  Widget build(BuildContext context) {
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
                  icon:
                      Icon(const IconData(0xe152, fontFamily: 'MaterialIcons')),
                  onPressed: null)
            ]),
        body: Container(
            child: FutureBuilder(
                future: fetchPost(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return _buildGroups(snapshot);
                })));
  }

  Widget _buildGroups(AsyncSnapshot snap) {
    return new ListView.separated(
        padding: const EdgeInsets.all(25),
        separatorBuilder: (context, index) => Divider(
              height: 30.0,
              color: Colors.white70,
            ),
        itemCount: snap.data.length,
        itemBuilder: (BuildContext _context, int index) {
          if (index < snap.data.length) {
            return _buildRow(snap.data[index]);
          }
        });
  }

  Widget _buildRow(Session studyGroup) {
    final String courseList =
        studyGroup.courses.replaceAll(new RegExp(r';'), ', ');

    DateTime start = DateTime.parse(studyGroup.start_time);
    DateTime end = DateTime.parse(studyGroup.end_time);

    String startTime = "${start.hour.toString()}:${start.minute.toString().padLeft(2,'0')}";
    String endTime = "${end.hour.toString()}:${end.minute.toString().padLeft(2,'0')}";

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
                    Text(studyGroup.title,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(courseList),
                  ],
                ),
                Column(
                  children: [
                    Text(startTime + ' - ' + endTime),
                    SizedBox(height: 10),
                    Text(studyGroup.building,
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    SizedBox(height: 10),
                    Text(' ',
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
