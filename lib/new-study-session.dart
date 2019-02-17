// File to implement the functionality and widgets for creation of a new study session

import 'package:flutter/material.dart';

class NewStudySession extends StatelessWidget {

  final List<String> listOfClasses = <String>['2AA4,'
      '2GA3', '2FA3', '2XB3', '2CO3'];

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
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, i){
                return ListTile(
                  /*title: Text(

                  )*/
                );
              },
            )
          ],
        )
    );
  }
}