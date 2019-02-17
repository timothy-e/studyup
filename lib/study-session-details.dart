// File which will implement the widgets and functionality for showing the study
// session details and being able to add/leave

import 'package:flutter/material.dart';

class StudySessionDetails extends State<SessionDetails> {
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Testing')
        )
      );
  }
}

class SessionDetails extends StatefulWidget {
  @override
  StudySessionDetails createState() => new StudySessionDetails();
}