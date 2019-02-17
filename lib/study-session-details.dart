// File which will implement the widgets and functionality for showing the study
// session details and being able to add/leave

import 'package:flutter/material.dart';

class StudySessionDetails extends State<SessionDetails> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,
          centerTitle: true, title: Text('Title | Endorsement')),
      body: _detailsPanel(),
    );
  }

  Widget _detailsPanel() {
    return new Container(
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(50.0),
          color: Colors.brown[100],
        ),
        padding: EdgeInsets.all(40),
        child: Center(
            child: Column(children: [
          Text('Time', style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 30),
          Text('Course', style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 30),
          Text('Building', style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 30),
          Text('People:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
          new DropdownButton<String>(
            items: <String>['P1', 'P2', 'P3', 'P4'].map((String value) {
              return new DropdownMenuItem<String>(
                value: value,
                child: new Text(value),
              );
            }).toList(),
            onChanged: (_) {},
          ),
          Text('Organizer Notes:', style: TextStyle(fontSize: 20.0)),
          new Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(70),
            decoration: new BoxDecoration(
                border: new Border.all(color: Colors.black87)
            ),
            child: new Text("                                         ")
          ),
          SizedBox(height: 10),
          RaisedButton(
            onPressed: null,
            padding: const EdgeInsets.all(5),
            child: const Text('Join', style: TextStyle(color: Colors.black87),),
          )
        ])));
  }
}

class SessionDetails extends StatefulWidget {
  @override
  StudySessionDetails createState() => new StudySessionDetails();
}
