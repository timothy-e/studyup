// File to implement the widgets and functionality for showing user profile

import 'package:flutter/material.dart';

class ProfileState extends State<Profile> {

  //final Set<String> listOfClasses = new Set<String>();
  final List<String> listOfClasses = <String>['2AA4',
  '2GA3', '2FA3', '2XB3', '2CO3'];
  final TextStyle _courseFont = const TextStyle(fontSize: 16.0);
  final TextStyle _instructionFont = const TextStyle(fontSize: 12.0);
  final TextStyle _infoFont = const TextStyle(fontSize: 14.0);
  final myController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(centerTitle: true, title: Text('User Name')),
        body: Column(
          children: <Widget>[
            Text('Email: joshua.guinness@gmail.com', style: _infoFont),
            Text('Below are listed the classes that you are a part of', style: _instructionFont),
            Container(
                margin: const EdgeInsets.all(10.0),
                height: 400.0,
                child: _buildClasses()
            ),
            Text('If you would like to add a class, type it below'
                'then click the add button.', style: _instructionFont),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Please enter your course code e.g. 2aa4',
                      ),
                      controller: myController
                  )
                ),
                Expanded(
                    child: IconButton(icon: const Icon(Icons.add_box),
                        onPressed: (){
                          setState(() {
                            listOfClasses.add(myController.text);
                          });
                        },
                    )
                )
              ],
            ),
            Text('Total number of endorsments: 25',
              style: TextStyle(color: Colors.yellow[800], fontSize: 14.0))
          ],
        )
    );
  }

  Widget _buildClasses(){
    return new ListView.separated(
        padding: const EdgeInsets.all(25),
        itemCount: listOfClasses.length,
        separatorBuilder: (context, index) => Divider(
          height: 0.0,
          color: Colors.white70,
        ),
        itemBuilder: (BuildContext _context, int index){
          if (index < listOfClasses.length){
            return _buildClass(listOfClasses[index], index);
          }
        }
    );
  }

  Widget _buildClass(String classes, int index){
    return ListTile(
        title: Center(
            child: Text(
              classes,
              style: _courseFont,
            )
        ),
        trailing: new Icon(
          Icons.delete
        ),
        onTap: (){
          setState((){
            listOfClasses.removeAt(index);
          });
        }
    );
  }
}

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => new ProfileState();
}
