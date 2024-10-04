import "dart:convert";
import "dart:typed_data";
import "package:crypto/crypto.dart";

class User {
  final int? id;
  final String email;
  final String passwordHash;
  final double weight;
  final double height;
  final DateTime birthDate;
  final double constanteInsulinica; // alguem tem que me explicar q poha é essa
  final String name;
  final String surname;

  User({
    this.id,
    required this.email,
    required senha,
    required this.weight,
    required this.height,
    required this.birthDate,
    required this.constanteInsulinica,
    required this.name,
    required this.surname,
  }) : passwordHash = hashPassword(senha);

  Map<String, dynamic> toMap() {
    // toJSON (?)
    return {
      'id': id,
      'email': email,
      'senha': passwordHash,
      'weight': weight,
      'height': height,
      'data_nascimento': birthDate.toIso8601String(),
      'const_insulinica': constanteInsulinica,
      'name': name,
      'surname': surname
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    // fromJSON (?)
    return User(
      id: map["id"],
      email: map["email"],
      senha: map["senha"],
      weight: map["peso"],
      height: map["altura"],
      birthDate: DateTime.parse(map["data_nascimento"]),
      constanteInsulinica: map["const_insulinica"],
      name: map["nome"],
      surname: map["sobrenome"],
    );
  }

  static String hashPassword(String password) {
    final Uint8List bytes = utf8.encode(password);
    final Digest hashedPassword = sha256.convert(bytes);
    return hashedPassword.toString();
  }
}
