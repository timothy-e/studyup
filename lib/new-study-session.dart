// File to implement the functionality and widgets for creation of a new study session

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class Session {
  String title;
  int id;
  String start_time;
  String end_time;
  String building;
  String courses;
  String notes;
  String host_user;

  Session(
      {this.title, this.id,
        this.start_time,
        this.end_time,
        this.building,
        this.courses, this.notes, this.host_user});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        title: json['title'],
        id: json['id'],
        start_time: json['start_time'],
        end_time: json['end_time'],
        building: json['building'],
        courses: json['courses'],
        notes: json['notes'],
        host_user: json['host_user']);
  }
}

Future<List<String>> fetchPost() async {
  http.Response resp = await http.get('http://studyup.appspot.com/usercourses/?name=Tim');

  String response = json.decode(resp.body);
  List<String> theCourses = response.split(";");
  return theCourses;
}

class NewStudySessionState extends State<NewStudySession> {

  Future<List<String>> info;
  @override
  void initState() {
    super.initState();
    info = fetchPost();
  }

  final List<String> listOfClasses = <String>['2AA4',
      '2GA3', '2FA3', '2XB3', '2CO3'];
  final TextStyle _courseFont = const TextStyle(fontSize: 18.0);
  final TextStyle _instructionFont = const TextStyle(fontSize: 14.0);
  final Set<String> classesToInclude = new Set<String>();
  final newSession = new Session();
  final newBuilding = TextEditingController();
  final newNotes = TextEditingController();
  final newTitle = TextEditingController();

  Widget build(BuildContext context){
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            centerTitle: true,
            title: Text('Create A New Study Session', style: _instructionFont),
            backgroundColor: Colors.black
        ),
        body: Column(
          children: <Widget>[
            Text('Pick the classes you want to have '
                ' the study session for!', style: _instructionFont),
            Container(
              child: FutureBuilder(
                  future: fetchPost(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    while (snapshot.hasError) {
                      //return Text("Loading...");
                    }
                    return _buildClasses(snapshot);
            }
              ),
                margin: const EdgeInsets.all(10.0),
                height: 200.0,
            ),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Please enter a title for your study sessions'
              ),
              controller: newTitle,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Pick your starting time.', style: _instructionFont)
                ),
                Expanded(
                  child: IconButton(icon: const Icon(Icons.timer),
                      onPressed: (){
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                            }, currentTime: DateTime.now(), locale: LocaleType.en);
                      }),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text('Pick your ending time.', style: _instructionFont)
                ),
                Expanded(
                  child: IconButton(icon: const Icon(Icons.timer),
                      onPressed: (){
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                            }, currentTime: DateTime.now(), locale: LocaleType.en);
                      }),
                )
              ],
            ),
            TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter the name of your building'
                ),
                controller: newBuilding
            ),
            TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter in additional details of what you '
                        'are studying including location within the building, '
                        'what is being studied/worked on, etc.'
                ),
                controller: newNotes
            ),
            RaisedButton(
                onPressed: (){
                  newSession.building = newBuilding.toString();
                  newSession.notes = newNotes.toString();
                  newSession.title = newTitle.toString();
                  newSession.host_user = "Tim";

                },
                child: Text('Create', style: TextStyle(fontSize: 18, color: Colors.brown[100]))
            )
          ],
        )
    );
  }

  Widget _buildClasses(AsyncSnapshot snapshot){
    return new ListView.separated(
      padding: const EdgeInsets.all(25),
        itemCount: snapshot.data.length,
        separatorBuilder: (context, index) => Divider(
          height: 0.0,
          color: Colors.white70,
        ),
      itemBuilder: (BuildContext _context, int index){
        if (index < snapshot.data.length){
          return _buildClass(snapshot.data[index]);
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
          style: _courseFont,
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

  void postRequest(){

  }

}

class NewStudySession extends StatefulWidget{
  @override
  NewStudySessionState createState() => new NewStudySessionState();
}