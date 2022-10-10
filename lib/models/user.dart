import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;
  final String password;
  final String joiningDate;
  final String department;
  final String phoneNumber;
  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      required this.token,
      required this.password,
      required this.joiningDate,
      required this.department,
      required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'token': token,
      'password': password,
      'joiningDate': joiningDate,
      'department': department,
      'phoneNumber': phoneNumber
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['_id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        role: map['role'] ?? '',
        token: map['token'] ?? '',
        password: map['password'] ?? '',
        joiningDate: map['joiningDate'] ?? '',
        department: map['departmentx'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
