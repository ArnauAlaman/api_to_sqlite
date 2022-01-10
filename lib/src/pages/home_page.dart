import 'package:api_to_sqlite/src/models/student_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:api_to_sqlite/src/providers/student_api_provider.dart';
import 'package:flutter/material.dart';

String inputStudentName = "";
String inputStudentSurName = "";
String inputStudentEmail = "";
bool newInput = false;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Students List'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[

          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.refresh),tooltip: 'Air it',
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom:25),
        child: FloatingActionButton(
          elevation: 5,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondRoute()),
              );
            },
          backgroundColor: Colors.red,
          child: Icon(
            Icons.add,
            size:32,
            color: Colors.white,

          )

        ),
      ),


      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),

            )
          : _buildStudentsListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = StudentApiProvider();
    await apiProvider.getAllStudents();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllStudents();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    // ignore: avoid_print
    //print('All employees deleted');
  }


  _buildStudentsListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllStudents(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(

                leading: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 20.0),
                ),
                 title: Text(
                    "Name: ${snapshot.data[index].firstName} ${snapshot.data[index].lastName} "),
                subtitle: Text('${snapshot.data[index].email}'),
              );

            },
          );
        }
      },
    );

  }
}


class SecondRoute extends StatelessWidget {

  const SecondRoute({Key? key}) : super(key: key);

  @override

  void ShowDialog (BuildContext context, String msg){
    context: context;
    builder: (BuildContext context) => AlertDialog(
    title: const Text('AlertDialog Title'),
    content: const Text('AlertDialog description'),
    actions: <Widget>[
    TextButton(
    onPressed: () => Navigator.pop(context, 'Cancel'),
    child: const Text('Cancel'),
    ),
    TextButton(
    onPressed: () => Navigator.pop(context, 'OK'),
    child: const Text('OK'),
    ),
    ],
    );
  }

  Future<void> AddNewStudent(BuildContext context) async {

    if (inputStudentEmail != null && inputStudentSurName != null && inputStudentName != null
    && inputStudentEmail != "" && inputStudentSurName != "" && inputStudentName != ""){


      Students newStudent = new Students();
      newStudent.email = inputStudentEmail;
      newStudent.firstName = inputStudentName;
      newStudent.lastName = inputStudentSurName;

      DBProvider.db.createStudent(newStudent);
      ShowDialog(context, "Student created");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

      if(!newInput){
        newInput = true;
      }
      inputStudentSurName = "";
      inputStudentName = "";
      inputStudentEmail = "";
    }else{

      newInput = false;
      ShowDialog(context, "Error creating the student");
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new Student!  "),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
            children: <Widget>[

            Container(
            width: 350,
            padding: EdgeInsets.all(10.0),
            child: TextField(
                onChanged: (texto) {
                  inputStudentName = texto;
                },
                autofocus: true,
                style: TextStyle(decoration: TextDecoration.none),
                //onChanged: (v) => nameController.text = v,
                decoration: new InputDecoration(
                  labelText: 'Name of the Student',
                  border: OutlineInputBorder()
                )
            ),
        ),
        Container(
            width: 350,
            padding: EdgeInsets.all(10.0),
          child: TextField(
              onChanged: (texto) {

                inputStudentSurName = texto;
              },
              autofocus: true,
              style: TextStyle(decoration: TextDecoration.none),
              //onChanged: (v) => nameController.text = v,
              decoration: new InputDecoration(
                  labelText: 'Surname of the Student',
                  border: OutlineInputBorder()
              )
          ),
        ),Container(
                width: 350,
                padding: EdgeInsets.all(10.0),
                child: TextField(
                    onChanged: (texto) {
                      inputStudentEmail = texto;
                    },
                    autofocus: true,
                    style: TextStyle(decoration: TextDecoration.none),
                    //onChanged: (v) => nameController.text = v,
                    decoration: new InputDecoration(
                        labelText: 'Email of the Student',
                        border: OutlineInputBorder()
                    )
                ),
              ),RaisedButton(
                onPressed:()=> AddNewStudent(context),
                color: Colors.red,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text('Create Student'),
              ),

        ]),
      ),
    );
  }
}

