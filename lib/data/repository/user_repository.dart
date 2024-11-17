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

  Future<int> deleteUser(int id) {
    return _userDAO.deleteUser(id);
  }
}
