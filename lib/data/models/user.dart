class User {
  final int? id;
  final String email;
  final String senha;
  final double peso;
  final double altura;
  final DateTime dataNascimento;
  final double constanteInsulinica; // alguem tem que me explicar q poha é essa
  final String nome;
  final String sobrenome;

  User({
    this.id,
    required this.email,
    required this.senha,
    required this.peso,
    required this.altura,
    required this.dataNascimento,
    required this.constanteInsulinica,
    required this.nome,
    required this.sobrenome,
  });

  Map<String, dynamic> toMap() {
    // toJSON (?)
    return {
      'id': id,
      'email': email,
      'senha': senha,
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
}
