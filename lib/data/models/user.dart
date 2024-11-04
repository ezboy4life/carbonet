import "dart:convert";
import "dart:typed_data";
import "package:crypto/crypto.dart";

class User {
  final int? id;
  final String email;
  final String passwordHash;
  final DateTime birthDate;
  final double constanteInsulinica; // proporção carboidratos - dose de insulina
  final String name;
  final String surname;
  final int minBloodGlucose;
  final int maxBloodGlucose;

  User({
    this.id,
    required this.email,
    required senha,
    required this.birthDate,
    required this.constanteInsulinica,
    required this.name,
    required this.surname,
    required this.minBloodGlucose,
    required this.maxBloodGlucose,
  }) : passwordHash = hashPassword(senha);

  Map<String, dynamic> toMap() {
    // toJSON (?)
    return {
      'id': id,
      'email': email,
      'senha': passwordHash,
      'dataNascimento': birthDate.toIso8601String(),
      'constInsulinica': constanteInsulinica,
      'nome': name,
      'sobrenome': surname,
      'glicemiaMinima': minBloodGlucose,
      'glicemiaMaxima': maxBloodGlucose,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    // fromJSON (?)
    return User(
      id: map["id"],
      email: map["email"],
      senha: map["senha"],
      birthDate: DateTime.parse(map["dataNascimento"]),
      constanteInsulinica: map["constInsulinica"],
      name: map["nome"],
      surname: map["sobrenome"],
      minBloodGlucose: map["glicemiaMinima"],
      maxBloodGlucose: map["glicemiaMaxima"],
    );
  }

  static String hashPassword(String password) {
    final Uint8List bytes = utf8.encode(password);
    final Digest hashedPassword = sha256.convert(bytes);
    return hashedPassword.toString();
  }
}
