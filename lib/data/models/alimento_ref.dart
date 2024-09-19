// nota: esse modelo é um mix de duas tabelas. ele serve para tanto definir os alimentos de referência, como para definir se X alimento é um favorito para uma refeição Y.

// quando eu puxo uma entrada da tabela alimentoReferencia, todos os campos menos o "qtd_ingerida" são setados; nessa brincadeira, quando eu puxar os valores de alimentoFreq, ocorre uma coisa terrivelmente feia para mapear os favoritos. infelizmente a alternativa seria manter uma tabela de alimentos em que constasse a configuração de favoritos para cada usuário, então por ora vai ficar a loucura mesmo.

// quando eu crio um alimentoIngerido para usar na lista de alimentos selecionados, vai tanto o id desse alimento (que é salva no bd), quanto uma referência interna para esse objeto todo (que não é salva no bd).

class AlimentoRef {
  final int id;
  final String nome;
  final String porcao;
  final double gramasPorPorcao;
  final double carbosPorPorcao;
  final double carbosPorGrama;

  bool favCafe;
  bool favAlmoco;
  bool favJanta;
  bool favLanche;

  AlimentoRef(
      {required this.id,
      required this.nome,
      required this.porcao,
      required this.gramasPorPorcao,
      required this.carbosPorPorcao,
      required this.carbosPorGrama,
      this.favCafe = false,
      this.favAlmoco = false,
      this.favJanta = false,
      this.favLanche = false});

  static AlimentoRef fromId(int id) {
    // usar o DAO para buscar essa instância do alimento na db
    return AlimentoRef(id: 0, nome: "a", porcao: "b", gramasPorPorcao: 0, carbosPorPorcao: 0, carbosPorGrama: 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'porcao': porcao,
      'gramasPorPorcao': gramasPorPorcao,
      'carbosPorPorcao': carbosPorPorcao,
      'carbosPorGrama': carbosPorGrama,
      'favCafe': favCafe,
      'favAlmoco': favAlmoco,
      'favJanta': favJanta,
      'favLanche': favLanche
    };
  }

  factory AlimentoRef.fromMap(Map<String, dynamic> map) {
    return AlimentoRef(
        id: map['id'],
        nome: map['nome'],
        porcao: map['porcao'],
        gramasPorPorcao: double.parse(map['gramas_por_porcao'] == "-" ? "-1" : map['gramas_por_porcao']),
        carbosPorPorcao: double.parse(map['carbos_por_porcao']),
        carbosPorGrama: double.parse(map['carbos_por_grama'] == "#VALUE!" ? "-1" : map['carbos_por_grama']),
        favCafe: map['favCafe'] == 1 ? true : false,
        favAlmoco: map['favAlmoco'] == 1 ? true : false,
        favJanta: map['favJanta'] == 1 ? true : false,
        favLanche: map['favLanche'] == 1 ? true : false);
  }
}
