// File to implement the functionality and widgets for creation of a new study session

import 'package:flutter/material.dart';

class NewStudySession extends StatelessWidget {

  final List<String> listOfClasses = <String>['2AA4,'
      '2GA3', '2FA3', '2XB3', '2CO3'];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title: Center (
                child: Text('Create A New Study Session')
            )
        ),
        body: Column(
          children: <Widget>[
            Text('Pick the classes you want to have the study session for!'),
            _buildClasses()
          ],
        )
    );
  }
  
  Widget _buildClasses(){
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext _context, int index){
        if (index < listOfClasses.length){
          return _buildClass(listOfClasses[index]);
        }
      }
    );
  }

  Widget _buildClass(String classes){
    return new ListTile(
      title: new Text(
        classes,
        style: _biggerFont,
      ),
    );
  }

}
/*
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
*/