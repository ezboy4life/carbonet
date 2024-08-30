import 'package:carbonet/data/models/alimento_ingerido.dart';

class Refeicao {
  int id;
  int idUser;
  String tipoRefeicao;
  DateTime data;
  bool isActive;

  final List<AlimentoIngerido> localListaAlimentosIngeridos = [];

  // é uma boa, no DAO, não continuar a operação sem ter idUser > -1 e a qtdIngerida > 0; estourar uma exception e tudo o mais
  Refeicao({
    this.id = -1,
    required this.idUser,
    required this.data,
    required this.tipoRefeicao,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    if (id == -1) {
      return {
        'idUser': idUser,
        'data': data.toIso8601String(),
        'tipoRefeicao': tipoRefeicao,
      };
    } else {
      return {
        'id': id,
        'idUser': idUser,
        'data': data.toIso8601String(),
        'tipoRefeicao': tipoRefeicao,
        'isActive': isActive,
      };
    }

    
  }

  factory Refeicao.fromMap(Map<String, dynamic> map) {
    return Refeicao(
      id: map['id'],
      idUser: map['idUser'],
      data: DateTime.parse(map['data']),
      tipoRefeicao: map['tipoRefeicao'],
      isActive: map['isActive'] == 1 ? true : false,
    );
  }
}