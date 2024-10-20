import 'package:flutter/widgets.dart';

class MyAppState extends ChangeNotifier {
  bool isAuth = false;
  var preferences = [];
  var history = <String>[];
  int pageSate = 0;

  // New user information fields
  String userSex = "";
  String userName = "";
  String userAge = "";
  String userHealthRisks = "";

  void setPageSate(int page) {
    pageSate = page;
    notifyListeners();
  }

  // Setter methods for user info
  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }

  void setUserSex(String sex) {
    userSex = sex;
    notifyListeners();
  }

  void setUserAge(String age) {
    userAge = age;
    notifyListeners();
  }

  void setUserHealthRisks(String healthRisks) {
    userHealthRisks = healthRisks;
    notifyListeners();
  }

  void login() {
    isAuth = true;
    notifyListeners();
  }

  void logout() {
    isAuth = false;
    notifyListeners();
  }
}
