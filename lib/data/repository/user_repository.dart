import 'package:carbonet/data/database/user_dao.dart';
import 'package:carbonet/data/models/user.dart';

class UserRepository {
  final UserDAO _userDAO = UserDAO();

  Future<int> addUser(User user) {
    return _userDAO.insertUser(user);
  }

  Future<User?> fetchUserFromId(int id) async {
    return _userDAO.getUserFromId(id);
  }

  Future<User?> fetchUserFromEmail(String email) async {
    return _userDAO.getUserFromEmail(email);
  }

  Future<User?> fetchUserFromLogin(String email, String password) {
    return _userDAO.getUserFromLogin(email, password);
  }

  Future<List<User>> fetchAllUsers() {
    return _userDAO.getAllUsers();
  }

  Future<int> updateUser(User user) {
    return _userDAO.updateUser(user);
  }

  Future<int> updateUserEmail(User user) {
    return _userDAO.updateUserEmail(user);
  }

  Future<int> updateUserPassword(User user) {
    return _userDAO.updateUserPassword(user);
  }

  Future<int> updateUserInsulin(User user) {
    return _userDAO.updateUserInsulin(user);
  }

  Future<int> updateUserName(User user) {
    return _userDAO.updateUserName(user);
  }

  Future<int> updateUserSurname(User user) {
    return _userDAO.updateUserSurname(user);
  }

  Future<int> updateUserMaxBloodGlucose(User user) {
    return _userDAO.updateUserMaxBloodGlucose(user);
  }

  Future<int> updateUserMinBloodGlucose(User user) {
    return _userDAO.updateUserMinBloodGlucose(user);
  }

  Future<int> updateUserBirthDate(User user) {
    return _userDAO.updateUserBirthDate(user);
  }

  Future<int> deleteUser(int id) {
    return _userDAO.deleteUser(id);
  }
}
