# StudyUp!

Created at BrickHacks at the Rochester Institute of Technology. The Devpost for it can be found here: https://devpost.com/software/studyup-5ezxyw. 

The purpose of this app is to connect people at Universities/Colleges who are looking to study with other people.

A main problem students face is that they struggle to find people to study with. This results in less fruitful studying and a lack of understanding of key concepts, overall resulting in lower grades. This app solves this by providing a platform for students to find study sessions based on the classes they are in, and for students to create study sessions that other students can join.

We also planned to add some unique features to this app such as an endorsement system for people that are knowledgeable in that particular class.

The main page, seen below, shows a list of all active study sessions based on the classes that the user is enrolled in.

<img src="https://github.com/joshuaguinness/studyup/blob/master/App%20Screenshots/Screenshot_20190318-121710.jpg" width="300">

Clicking on one of the study sessions brings you to this page seen below. This page is incomplete so far.

<img src="https://github.com/joshuaguinness/studyup/blob/master/App%20Screenshots/Screenshot_20190318-121733.jpg" width="300">

Going back on the main screen, clicking on the user icon (top left), brings you to this page. Here you can edit the courses you are enrolled in and see your endorsement level. 

<img src="https://github.com/joshuaguinness/studyup/blob/master/App%20Screenshots/Screenshot_20190318-121718.jpg" width="300">

Again going back to the main screen, clicking on the "+" icon (top right) will bring you to this page. This will allow a user to create a new study session.

<img src="https://github.com/joshuaguinness/studyup/blob/master/App%20Screenshots/Screenshot_20190318-121727.jpg" width="300">

## Creation

This app was created using flutter (https://flutter.dev/), Google's open source app development platform that allows simultaneous development on iOS and Android. The language used for programming this is Dart. Both of these were new but both were pretty easy to pickup after reading documentation, walking through some tutorials, and thinking critically about how they are structured. It is definitly much easier than native android development using Java.

To store our info, we used a Google cloud server then used POST and GET requests via REST API's to send and get data for the app. Implementing this was definitely the hardest part as it was new for everyone but we were successfully able to get some info from the server to the app.


## To Use
`source /env/bin/activate/` to enter the virtual environment and set up variables.

pip install the requirements to `lib/`

`./cloud_sql_proxy -instances=studyup:us-central1:studyup-mysql=tcp:3306` to launch the SQL instance.

`python main.py` to launch the web application.

Visit `localhost:8080` to check it out!
