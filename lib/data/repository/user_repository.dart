import 'package:carbonet/data/database/user_dao.dart';
import 'package:carbonet/data/models/user.dart';

class UserRepository {
  final UserDAO _userDAO = UserDAO();

  Future<int> addUser(User user) {
    return _userDAO.insertUser(user);
  }

  Future<List<User>> fetchAllUsers() {
    return _userDAO.getAllUsers();
  }

  Future<int> updateUser(User user) {
    return _userDAO.updateUser(user);
  }

  Future<int> deleteUser(int id) {
    return _userDAO.deleteUser(id);
  }
}
