import 'package:coderz_inc/models/user.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    token: '',
    email: '',
    role: '',
    password: '',
    department: '',
    joiningDate: '',
    phoneNumber: '',
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
