class Glicemia {
  int id;
  final int idUser;
  double glicemia;
  DateTime data;

  Glicemia({
    this.id = -1,
    required this.idUser,
    required this.glicemia,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    if (id == -1) {
      return {
        'idUser': idUser,
        'glicemia': glicemia,
        'data': data.toIso8601String(),
      };
    } else {
      return {
        'id': id,
        'idUser': idUser,
        'glicemia': glicemia,
        'data': data.toIso8601String(),
      };
    }
  }

  factory Glicemia.fromMap(Map<String, dynamic> map) {
    return Glicemia(
      id: map['id'],
      idUser: map['idUser'],
      glicemia: (map['glicemia']),
      data: DateTime.parse(map['data']),
    );
  }
}