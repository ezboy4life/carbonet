import "dart:convert";
import "dart:typed_data";
import "package:crypto/crypto.dart";

class User {
  final int? id;
  final String email;
  final String senhaHash;
  final double peso;
  final double altura;
  final DateTime dataNascimento;
  final double constanteInsulinica; // alguem tem que me explicar q poha é essa
  final String nome;
  final String sobrenome;

  User({
    this.id,
    required this.email,
    required senha,
    required this.peso,
    required this.altura,
    required this.dataNascimento,
    required this.constanteInsulinica,
    required this.nome,
    required this.sobrenome,
  }) : senhaHash = hashPassword(senha);

  Map<String, dynamic> toMap() {
    // toJSON (?)
    return {
      'id': id,
      'email': email,
      'senha': senhaHash,
      'peso': peso,
      'altura': altura,
      'data_nascimento': dataNascimento.toIso8601String(),
      'const_insulinica': constanteInsulinica,
      'nome': nome,
      'sobrenome': sobrenome
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    // fromJSON (?)
    return User(
      id: map["id"],
      email: map["email"],
      senha: map["senha"],
      peso: map["peso"],
      altura: map["altura"],
      dataNascimento: DateTime.parse(map["data_nascimento"]),
      constanteInsulinica: map["const_insulinica"],
      nome: map["nome"],
      sobrenome: map["sobrenome"],
    );
  }

  static String hashPassword(String password) {
    final Uint8List bytes = utf8.encode(password);
    final Digest hashedPassword = sha256.convert(bytes);
    return hashedPassword.toString();
  }
}
