// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bson/src/classes/object_id.dart';
import 'package:coderz_inc/dbHelper/mongodb.dart';
import 'package:coderz_inc/utils/bar_chart_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// ############################################################################
// ############################################################################
class PieChatPage extends StatelessWidget {
  final totalBreakTime,
      totalMeetingTime,
      totalWorkTime,
      ptotalBreakTime,
      ptotalWorkTime,
      ptotalMeetingTime;
  PieChatPage(
      {super.key,
      required this.totalBreakTime,
      required this.totalMeetingTime,
      required this.totalWorkTime,
      required this.ptotalBreakTime,
      required this.ptotalWorkTime,
      required this.ptotalMeetingTime});

  @override
  Widget build(BuildContext context) {
    final List<BarChartModel> data = [
      BarChartModel(
        eventType: "Working",
        time: int.parse(totalWorkTime),
        color: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      BarChartModel(
        eventType: "Meeting",
        time: int.parse(totalMeetingTime),
        color: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      BarChartModel(
        eventType: "Not Working",
        time: int.parse(totalBreakTime),
        color: charts.ColorUtil.fromDartColor(Colors.red),
      ),
    ];
    Map<String, double> dataMap_ThatDay = {
      "Meeting": double.parse(totalMeetingTime),
      "Break": double.parse(totalBreakTime),
      "Work": double.parse(totalWorkTime),
    };
    Map<String, double> dataMap_AfterDay = {
      "Meeting": double.parse(ptotalMeetingTime),
      "Break": double.parse(ptotalBreakTime),
      "Work": double.parse(ptotalWorkTime),
    };

    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
        id: "time",
        data: data,
        domainFn: (BarChartModel series, _) => series.eventType,
        measureFn: (BarChartModel series, _) => series.time,
        colorFn: (BarChartModel series, _) => series.color,
      ),
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // // color: Colors.blue[200],
          decoration: BoxDecoration(
            color: Colors.blue[100],
            // borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Current Day"),
              ),
              PieChart(
                dataMap: dataMap_ThatDay,
                chartRadius: MediaQuery.of(context).size.width / 1.9,
                chartValuesOptions: ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Previous Day"),
              ),
              PieChart(
                dataMap: dataMap_AfterDay,
                chartRadius: MediaQuery.of(context).size.width / 1.9,
                chartValuesOptions: ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                height: 350,
                child: charts.BarChart(
                  series,
                  animate: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// #####################################################################
// #####################################################################

class UpdateEmployee extends StatefulWidget {
  String email;
  UpdateEmployee({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  var name = "name",
      email = "email",
      phone = "phone",
      date = "joining date",
      department = "department",
      totalBreakTime = 0,
      totalWorkTime = 0,
      totalMeetingTime = 0,
      ptotalBreakTime = 0,
      ptotalWorkTime = 0,
      ptotalMeetingTime = 0;

  @override
  void initState() {
    MongoDatabase.getOneUser(widget.email).then((value) {
      setState(() {
        name = value[0]['name'].toString();
        email = value[0]['email'].toString();
        phone = value[0]['phoneNumber'].toString();
        date = value[0]['joiningDate'].toString();
        department = value[0]['department'].toString();
      });
    });

    var formatter = new DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(DateTime.now());

    MongoDatabase.getbreakTime(widget.email, formattedDate).then((value) {
      for (int i = 0; i < value.length; i++) {
        totalBreakTime += int.parse(value[i]['timeTaken'].toString());
      }
      setState(() {});
    });

    MongoDatabase.getWorkTime(widget.email, formattedDate).then((value) {
      for (int i = 0; i < value.length; i++) {
        totalWorkTime += int.parse(value[i]['timeTaken'].toString());
      }
      setState(() {});
    });
    MongoDatabase.getMeetingTime(widget.email, formattedDate).then((value) {
      for (int i = 0; i < value.length; i++) {
        totalMeetingTime += int.parse(value[i]['timeTaken'].toString());
      }
      setState(() {});
    });

    String pformattedData =
        formatter.format(DateTime.now().subtract(Duration(days: 1)));
    MongoDatabase.getbreakTime(widget.email, pformattedData).then((value) {
      for (int i = 0; i < value.length; i++) {
        ptotalBreakTime += int.parse(value[i]['timeTaken'].toString());
      }
      setState(() {});
    });

    MongoDatabase.getWorkTime(widget.email, pformattedData).then((value) {
      for (int i = 0; i < value.length; i++) {
        ptotalWorkTime += int.parse(value[i]['timeTaken'].toString());
      }
      setState(() {});
    });

    MongoDatabase.getMeetingTime(widget.email, pformattedData).then((value) {
      for (int i = 0; i < value.length; i++) {
        ptotalMeetingTime += int.parse(value[i]['timeTaken'].toString());
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            color: Colors.blue[200],
            child: Column(children: [
              Container(
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
              Container(
                  height: deviceHeight * 0.30,
                  width: double.infinity,
                  // color: Colors.green,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: LayoutBuilder(builder: (ctx, constraints) {
                    return Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   height: constraints.maxHeight * 0.01,
                          // ),
                          // Text('Please enter the details below to continue',),
                          Container(
                            height: constraints.maxHeight * 0.185,
                            width: deviceWidth * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.account_box),
                                ),
                                Text(
                                  "$name",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),
                          Container(
                            height: constraints.maxHeight * 0.185,
                            width: deviceWidth * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.email),
                                ),
                                Text(
                                  email,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),

                          Container(
                            height: constraints.maxHeight * 0.185,
                            width: deviceWidth * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.phone),
                                ),
                                Text(
                                  phone.toString(),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),

                          Container(
                            height: constraints.maxHeight * 0.185,
                            width: deviceWidth * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.date_range_outlined),
                                ),
                                Text(
                                  date,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),

                          Container(
                            height: constraints.maxHeight * 0.185,
                            width: deviceWidth * 0.90,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.password),
                                ),
                                Text(
                                  department,
                                ),
                              ],
                            ),
                          ),
                        ]);
                  })),

              SizedBox(
                height: deviceHeight * 0.01,
              ),

              // THis is where Charts start
              // ########################################################################

              Card(
                elevation: 8,
                shadowColor: Colors.black,
                child: Container(
                  height: deviceHeight * 0.40,
                  width: deviceWidth * 0.95,
                  color: Colors.blue[100],
                  child: PieChatPage(
                    totalBreakTime: totalBreakTime.toString(),
                    totalWorkTime: totalWorkTime.toString(),
                    totalMeetingTime: totalMeetingTime.toString(),
                    ptotalBreakTime: ptotalBreakTime.toString(),
                    ptotalWorkTime: ptotalWorkTime.toString(),
                    ptotalMeetingTime: ptotalMeetingTime.toString(),
                  ),
                  // decoration: BoxDecoration(
                  //   // color: Colors.blue[400],
                  //   borderRadius: BorderRadius.circular(25),
                  // ),
                ),
              ),

              // #########################################################################

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 60,
                  width: deviceWidth * 0.70,
                  // margin: EdgeInsets.only(
                  //   top: 0,
                  // ),
                  // color: Colors.red,
                  // child: ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text(
                  //     'Edit Profile',
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontSize: 22,
                  //         color: Colors.black),
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //       primary: Colors.blue[100],
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(60),
                  //       )),
                  // ),

                  // child: Container(
                  //   color: Colors.green,
                  //   height: deviceHeight * 0.05,
                  // ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    ));
  }
}
