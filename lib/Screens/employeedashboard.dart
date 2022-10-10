import 'package:coderz_inc/Screens/AddEvent.dart';
import 'package:coderz_inc/Screens/updateEmployee.dart';
import 'package:coderz_inc/dbHelper/mongodb.dart';
import 'package:coderz_inc/services/auth_services.dart';
import 'package:coderz_inc/utils/EventModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/user_provider.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  late String email = getUid().toString();
  DateTime date1 = DateTime.now();
  Future<String> getUid() async {
    final prefs = await SharedPreferences.getInstance();

    String email = prefs.getString('email').toString();
    return email;
  }

  @override
  void initState() {
    getUid().then((value) {
      setState(() {
        email = value.toString();
      });
    });
    super.initState();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        date1 = value!;
        var formatter = new DateFormat('dd/MM/yyyy');
        String formattedDate = formatter.format(date1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(date1);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Task List"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: ((context) {
                return {'Profile', 'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpdateEmployee(email: email.toString()),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 15),
                height: deviceHeight * 0.18,
                // color: Colors.black,
                child: const CircleAvatar(
                  radius: 75,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius: 73,
                    backgroundColor: Color.fromARGB(255, 66, 163, 242),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(
                        'assets/images/employee.png',
                        // D:\VS STUDIO\Ha\CoderzInc\Images\employee.png
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Text(
                Provider.of<UserProvider>(context).user.name,
                style: TextStyle(
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  // fontFamily:
                ),
              ),
            ),
            GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(formattedDate.toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.5,
                          // fontFamily:
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: _showDatePicker,
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(color: Colors.white),
            ),
            Container(
                height: deviceHeight * 0.60,
                width: double.infinity,
                // color: Colors.green,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder(
                    future: MongoDatabase.getUserEvents(email, formattedDate),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.hasData) {
                          var totalData = snapshot.data.length;
                          print("Total Data" + totalData.toString());
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Task(
                                    EventModel.fromJson(snapshot.data[index]),
                                    deviceHeight,
                                    deviceWidth);
                              });
                        } else {
                          return Center(
                            child: Text("No Data Available."),
                          );
                        }
                      }
                    }))
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddEvent()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget Task(EventModel eventModel, double deviceHeight, double deviceWidth) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${eventModel.eventTitle}"),
            SizedBox(
              height: 5,
            ),
            Text("${eventModel.eventDescription}"),
            SizedBox(
              height: 5,
            ),
            Text("${eventModel.eventType}"),
            SizedBox(
              height: 5,
            ),
            Text("${eventModel.duration}")
          ],
        ),
      ),
    );
  }

  final AuthService authService = AuthService();
  void handleClick(String value) {
    switch (value) {
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateEmployee(email: email.toString()),
          ),
        );
        break;
      case 'Logout':
        authService.signOut(context);
        break;
    }
  }
}
