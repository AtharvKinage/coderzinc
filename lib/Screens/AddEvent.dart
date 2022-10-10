import 'package:coderz_inc/Screens/employeedashboard.dart';
import 'package:coderz_inc/dbHelper/mongodb.dart';
import 'package:coderz_inc/utils/EventModel.dart';
import 'package:coderz_inc/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/user_provider.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

final items = ["Work", "Meeting", "Break"];
String? selectedItem = "Work";
// List<String> items = <String>["Work", "Meeting", "Break", "Other"];
// String dropDownValue = "Work";

class _AddEventState extends State<AddEvent> {
  var eventTitleController = TextEditingController();
  final TextEditingController eventDescriptionController =
      TextEditingController();
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
        var formatter = new DateFormat('dd/MM/yyyy');
        String formattedDate = formatter.format(date1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(date1);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin:
              const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
          // color: Color.fromARGB(255, 172, 172, 172),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 100,
                child: Icon(
                  Icons.edit_calendar,
                  size: 150,
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
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Event title",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20, left: 20),
                            child: TextField(
                              controller: eventTitleController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Enter event title',
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Event Description",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextField(
                              controller: eventDescriptionController,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Enter event Description',
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Event type",
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
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item),
                                          ))
                                      .toList(),
                                  onChanged: (item) =>
                                      setState(() => selectedItem = item),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Duration of event",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.alarm),
                                TextButton(
                                  onPressed: () async {
                                    TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: time,
                                    );
                                    if (newTime == null) return;
                                    setState(() => time = newTime);
                                  },
                                  child: Text(time.format(context)),
                                ),
                                const Text("To"),
                                TextButton(
                                  onPressed: () async {
                                    TimeOfDay? newTime = await showTimePicker(
                                        context: context, initialTime: time);
                                    if (newTime == null) return;
                                    setState(() => time1 = newTime);
                                  },
                                  child: Text(time1.format(context)),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Day of event",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 20),
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
        onPressed: () {
          var time1min = time1.hour * 60 + time1.minute;
          var timemin = time.hour * 60 + time.minute;
          var diff = time1min - timemin;
          _insertData(
              eventTitleController.text,
              eventDescriptionController.text,
              selectedItem.toString(),
              "${time.format(context)} to ${time1.format(context)}",
              formattedDate,
              diff.toString());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _insertData(String eventTitle, String eventDescription,
      String eventType, String duration, String day, String timeTaken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _id = M.ObjectId();
    final data = EventModel(
        id: _id,
        empId: prefs.getString('uid').toString(),
        eventTitle: eventTitle,
        eventDescription: eventDescription,
        eventType: eventType,
        duration: duration,
        day: day,
        timeTaken: timeTaken,
        email: prefs.getString('email').toString());
    var result = await MongoDatabase.insertEvent(data);
    showSnackBar(context, "Event added");
    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => EmployeeDashboard()));
    });
    print(result);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    eventTitleController.dispose();
    eventDescriptionController.dispose();
    super.dispose();
  }
}
