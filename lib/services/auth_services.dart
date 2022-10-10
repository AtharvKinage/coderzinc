import 'dart:convert';

import 'package:coderz_inc/Screens/AddEvent.dart';
import 'package:coderz_inc/Screens/AdminDashboardScreen.dart';
import 'package:coderz_inc/Screens/HomeScreen.dart';
import 'package:coderz_inc/Screens/LoginScreen.dart';
import 'package:coderz_inc/Screens/employeedashboard.dart';
import 'package:coderz_inc/models/user.dart';
import 'package:coderz_inc/provider/user_provider.dart';
import 'package:coderz_inc/utils/constants.dart';
import 'package:coderz_inc/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String role,
    required String department,
    required String joiningDate,
    required String phoneNumber,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        role: role,
        token: '',
        department: department,
        joiningDate: joiningDate,
        phoneNumber: phoneNumber,
      );
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Employee Added',
          );
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const AdminDashboardScreen(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          userProvider.setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          await prefs.setString('email', jsonDecode(res.body)['email']);
          await prefs.setString('uid', jsonDecode(res.body)['_id']);
          print(jsonDecode(res.body)['role']);
          if (jsonDecode(res.body)['role'] == "admin") {
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const AdminDashboardScreen(),
              ),
              (route) => false,
            );
          } else if (jsonDecode(res.body)['role'] == "user") {
            navigator.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const EmployeeDashboard(),
              ),
              (route) => false,
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('x-auth-token', '');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
}
