import "dart:convert";
import "dart:typed_data";
import "package:crypto/crypto.dart";

class User {
  final int? id;
  String email;
  String passwordHash;
  DateTime birthDate;
  double constanteInsulinica; // proporção carboidratos - dose de insulina
  String name;
  String surname;
  int minBloodGlucose;
  int maxBloodGlucose;

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
      birthDate: map["dataNascimento"] != null ? DateTime.parse(map["dataNascimento"]) : DateTime(2000) ,
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
