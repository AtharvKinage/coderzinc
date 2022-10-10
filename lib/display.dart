import 'package:coderz_inc/EmployeeModel.dart';
import 'package:coderz_inc/dbHelper/mongodb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MongoDisplay extends StatefulWidget {
  const MongoDisplay({super.key});

  @override
  State<MongoDisplay> createState() => _MongoDisplayState();
}

class _MongoDisplayState extends State<MongoDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        return displayCard(
                            MongoDbModel.fromJson(snapshot.data[index]));
                      });
                } else {
                  return Center(
                    child: Text("No Data Available."),
                  );
                }
              }
            }),
      )),
    );
  }

  Widget displayCard(MongoDbModel data) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${data.name}"),
          SizedBox(
            height: 5,
          ),
          Text("${data.department}"),
          SizedBox(
            height: 5,
          ),
          Text("${data.phoneNumber}"),
          SizedBox(
            height: 5,
          ),
          Text("${data.email}"),
        ],
      ),
    ));
  }
}
