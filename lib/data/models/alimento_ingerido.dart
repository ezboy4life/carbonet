// classe que registra os alimentos da refeição.

import 'package:carbonet/data/models/alimento_ref.dart';

class AlimentoIngerido {
  int id;
  final int idAlimentoReferencia;
  int idRefeicao;
  final double qtdIngerida;

  AlimentoRef? _alimentoReferencia;

  AlimentoRef get alimentoReferencia {
    _alimentoReferencia ??= AlimentoRef.fromId(idAlimentoReferencia);
    return _alimentoReferencia!;
  }

  set alimentoReferencia(AlimentoRef alimentoReferencia) {
    _alimentoReferencia = alimentoReferencia;
  }

  // é uma boa, no DAO, não continuar a operação sem ter o idRefeicao > -1 e a qtdIngerida > 0; estourar uma exception e tudo o mais (o próprio id feijoada pq ele é auto incremento)
  AlimentoIngerido({
    this.id = -1,
    required this.idAlimentoReferencia,
    this.idRefeicao = -1,
    this.qtdIngerida = 0,
    alimentoReferencia
  }): _alimentoReferencia = alimentoReferencia;

  Map<String, dynamic> toMap() {
    if (id == -1) {
      return {
        'idAlimentoReferencia': idAlimentoReferencia,
        'idRefeicao': idRefeicao,
        'qtdIngerida': qtdIngerida,
      };
    } else {
      return {
        'id': id,
        'idAlimentoReferencia': idAlimentoReferencia,
        'idRefeicao': idRefeicao,
        'qtdIngerida': qtdIngerida,
      };
    }
  }

  factory AlimentoIngerido.fromMap(Map<String, dynamic> map) {
    return AlimentoIngerido(
      id: map['id'],
      idAlimentoReferencia: map['idAlimentoReferencia'],
      idRefeicao: map['idRefeicao'],
      qtdIngerida: (map['qtdIngerida']) // n precisa de parse que nem no alimento referencia pq no sqlite ele tá salvo como double mesmo
    );    
  }
}