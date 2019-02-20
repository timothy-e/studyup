# studyup

## To Use
`source /env/bin/activate/` to enter the virtual environment and set up variables.

pip install the requirements to `lib/`

`./cloud_sql_proxy -instances=studyup:us-central1:studyup-mysql=tcp:3306` to launch the SQL instance.

`python main.py` to launch the web application.

Visit `localhost:8080` to check it out!

