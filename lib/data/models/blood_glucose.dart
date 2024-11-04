class BloodGlucose {
  int id;
  final int idUser;
  double bloodGlucose;
  DateTime date;
  int insulinDosage;
  int? idRefeicao;

  BloodGlucose({
    this.id = -1,
    required this.idUser,
    required this.bloodGlucose,
    required this.date,
    required this.insulinDosage,
    this.idRefeicao,
  });

  Map<String, dynamic> toMap() {
    if (id == -1) {
      return {
        'idUser': idUser,
        'glicemia': bloodGlucose,
        'data': date.toIso8601String(),
        'doseInsulina': insulinDosage,
        'idRefeicao': idRefeicao
      };
    } else {
      return {
        'id': id,
        'idUser': idUser,
        'glicemia': bloodGlucose,
        'data': date.toIso8601String(),
        'doseInsulina': insulinDosage,
        'idRefeicao': idRefeicao
      };
    }
  }

  factory BloodGlucose.fromMap(Map<String, dynamic> map) {
    return BloodGlucose(
      id: map['id'],
      idUser: map['idUser'],
      bloodGlucose: (map['glicemia']),
      date: DateTime.parse(map['data']),
      insulinDosage: map['doseInsulina'],
      idRefeicao: map['idRefeicao'],
    );
  }
}
