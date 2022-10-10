import 'dart:developer';

import 'package:coderz_inc/EmployeeModel.dart';
import 'package:coderz_inc/dbHelper/constant.dart';
import 'package:coderz_inc/utils/EventModel.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, userCollection, eventCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(USER_COLLECTION);
    eventCollection = db.collection("events");
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrData = await userCollection.find().toList();
    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getOneUser(email) async {
    final arrData =
        await userCollection.find(where.eq("email", email)).toList();
    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getbreakTime(email, date) async {
    final arrData = await eventCollection
        .find(where.eq("email", email).eq("day", date).eq("eventType", "Break"))
        .toList();
    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getWorkTime(email, date) async {
    final arrData = await eventCollection
        .find(where.eq("email", email).eq("day", date).eq("eventType", "Work"))
        .toList();
    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getMeetingTime(email, date) async {
    final arrData = await eventCollection
        .find(
            where.eq("email", email).eq("day", date).eq("eventType", "Meeting"))
        .toList();
    return arrData;
  }

  static Future<List<Map<String, dynamic>>> getUserEvents(
      String email, String date) async {
    final arrEvents = await eventCollection
        .find(where.eq("email", email).eq("day", date))
        .toList();

    print(date);

    // print(email);

    return arrEvents;
  }

  static Future<String> insert(MongoDbModel data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something Wrong while inserting data. ";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<String> insertEvent(EventModel data) async {
    try {
      var result = await eventCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something Wrong while inserting data. ";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
}
