import 'package:carbonet/data/models/user.dart';

class LoggedUserAccess {
  
  LoggedUserAccess._internal();

  static final LoggedUserAccess _instance = LoggedUserAccess._internal();
  
  User? user;

  factory LoggedUserAccess() {
    return _instance;
  }
}