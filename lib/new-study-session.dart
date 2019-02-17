// File to implement the functionality and widgets for creation of a new study session

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class NewStudySessionState extends State<NewStudySession> {

  final List<String> listOfClasses = <String>['2AA4',
      '2GA3', '2FA3', '2XB3', '2CO3'];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<String> classesToInclude = new Set<String>();

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
            Container(
              margin: const EdgeInsets.all(10.0),
              height: 200.0,
              child: _buildClasses()
            ),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Please enter a title for your study sessions'
              )
            ),
            Text('Pick your starting time.'),
            IconButton(icon: const Icon(Icons.timer),
                onPressed: (){
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                }),
            Text('Pick your ending time.'),
            IconButton(icon: const Icon(Icons.timer),
                onPressed: (){
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                })
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
    final bool alreadyChecked = classesToInclude.contains(classes);
    return ListTile(
      title: Center(
        child: Text(
          classes,
          style: _biggerFont,
        )
      ),
      trailing: new Icon(
          alreadyChecked ? Icons.check_box : Icons.check_box_outline_blank,
      ),
      onTap: (){
        setState((){
          if (alreadyChecked){
            classesToInclude.remove(classes);
          } else {
            classesToInclude.add(classes);
          }
        });
      }
    );
  }


}

class NewStudySession extends StatefulWidget{
  @override
  NewStudySessionState createState() => new NewStudySessionState();
}