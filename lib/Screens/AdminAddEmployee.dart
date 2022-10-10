import 'package:coderz_inc/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminAddEmployee extends StatefulWidget {
  const AdminAddEmployee({super.key});

  @override
  State<AdminAddEmployee> createState() => _AdminAddEmployee();
}

final items = ["user", "admin"];
String selectedItem = "user";

class _AdminAddEmployee extends State<AdminAddEmployee> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var departmentController = TextEditingController();
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay time1 = TimeOfDay.now();
  DateTime date1 = DateTime.now();
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      setState(() {
        date1 = value!;
      });
    });
  }

  final AuthService authService = AuthService();
  void signUp() {
    var formatter = new DateFormat('dd/MM/yyyy');
    authService.signUpUser(
      context: context,
      email: emailController.text,
      password: passwordController.text,
      department: departmentController.text,
      joiningDate: formatter.format(date1).toString(),
      name: nameController.text,
      phoneNumber: phoneNumberController.text,
      role: selectedItem,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          // color: Color.fromARGB(255, 172, 172, 172),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 100,
                child: Icon(
                  Icons.account_circle,
                  size: 190,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: const Color.fromARGB(255, 206, 206, 206),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 8, right: 8, top: 12),
                            child: Text(
                              "Employee Name",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20, left: 20),
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Enter Employee Name',
                              ),
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 8, right: 8, top: 12),
                            child: Text(
                              "Email",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Enter Employee Email',
                              ),
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 8, right: 8, top: 12),
                            child: Text(
                              "Contact Number",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              controller: phoneNumberController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Enter Contact Nmber',
                              ),
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 8, right: 8, top: 12),
                            child: Text(
                              "Department",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              controller: departmentController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Enter Department Name',
                              ),
                            ),
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 8, right: 8, top: 12),
                            child: Text(
                              "Role",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                DropdownButton<String>(
                                  value: selectedItem,
                                  items: items
                                      .map(
                                        (items) => DropdownMenuItem<String>(
                                          value: items,
                                          child: Text(items),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedItem = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Password",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Enter password',
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Joining Date",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 15, right: 20),
                                  child: Icon(Icons.calendar_month),
                                ),
                                TextButton(
                                  onPressed: _showDatePicker,
                                  child: Text(
                                      '${date1.day}/${date1.month}/${date1.year}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signUp,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    departmentController.dispose();
    super.dispose();
  }
}
