import 'package:coderz_inc/EmployeeModel.dart';
import 'package:coderz_inc/Screens/AdminAddEmployee.dart';
import 'package:coderz_inc/Screens/updateEmployee.dart';
import 'package:coderz_inc/dbHelper/mongodb.dart';
import 'package:coderz_inc/services/auth_services.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

String dropdownvalue = 'Item 1';

// List of items in our dropdown menu
final items = ['Name', 'Department'];

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Employees"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: ((context) {
                return {'Logout'}.map((String choice) {
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
              future: MongoDatabase.getData(),
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
                          return BuildScaffoldCard(
                              MongoDbModel.fromJson(snapshot.data[index]),
                              context);
                        });
                  } else {
                    return Center(
                      child: Text("No Data Available"),
                    );
                  }
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminAddEmployee(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget BuildScaffoldCard(MongoDbModel data, BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 12, bottom: 0, left: 12, right: 12),
        child: Container(
          height: 100,
          child: Card(
            color: Color.fromARGB(255, 206, 206, 206),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpdateEmployee(email: data.email.toString()),
                  ),
                );
              },
              splashColor: Colors.blue.withAlpha(30),
              child: Row(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text(
                              data.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.email),
                              SizedBox(
                                height: 5,
                              ),
                              Text(data.department)
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
  final AuthService authService = AuthService();
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        authService.signOut(context);
        break;
    }
  }
}
