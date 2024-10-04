// nota: esse modelo é um mix de duas tabelas. ele serve para tanto definir os alimentos de referência, como para definir se X alimento é um favorito para uma refeição Y.

// quando eu puxo uma entrada da tabela foodReference, todos os campos menos o "qtd_ingerida" são setados; nessa brincadeira, quando eu puxar os valores de alimentoFreq, ocorre uma coisa terrivelmente feia para mapear os favoritos. infelizmente a alternativa seria manter uma tabela de alimentos em que constasse a configuração de favoritos para cada usuário, então por ora vai ficar a loucura mesmo.

// quando eu crio um alimentoIngerido para usar na lista de alimentos selecionados, vai tanto o id desse alimento (que é salva no bd), quanto uma referência interna para esse objeto todo (que não é salva no bd).

class FoodReference {
  final int id;
  final String name;
  final String portion;
  final double gramsPerPortion;
  final double carbsPerPortion;
  final double carbsPerGram;

  bool favoriteCoffee;
  bool favoriteLunch;
  bool favoriteDinner;
  bool favoriteSnack;

  FoodReference(
      {required this.id,
      required this.name,
      required this.portion,
      required this.gramsPerPortion,
      required this.carbsPerPortion,
      required this.carbsPerGram,
      this.favoriteCoffee = false,
      this.favoriteLunch = false,
      this.favoriteDinner = false,
      this.favoriteSnack = false});

  static FoodReference fromId(int id) {
    // usar o DAO para buscar essa instância do alimento na db
    return FoodReference(id: 0, name: "a", portion: "b", gramsPerPortion: 0, carbsPerPortion: 0, carbsPerGram: 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': name,
      'porcao': portion,
      'gramas_por_porcao': gramsPerPortion,
      'carbos_por_porcao': carbsPerPortion,
      'carbos_por_grama': carbsPerGram,
      'favCafe': favoriteCoffee ? 1 : 0,
      'favAlmoco': favoriteLunch ? 1 : 0,
      'favJanta': favoriteDinner ? 1 : 0,
      'favLanche': favoriteSnack ? 1 : 0
    };
  }

  factory FoodReference.fromMap(Map<String, dynamic> map) {
    return FoodReference(
        id: map['id'],
        name: map['nome'],
        portion: map['porcao'],
        gramsPerPortion: double.parse(map['gramas_por_porcao'] == "-" ? "-1" : map['gramas_por_porcao']),
        carbsPerPortion: double.parse(map['carbos_por_porcao']),
        carbsPerGram: double.parse(map['carbos_por_grama'] == "#VALUE!" ? "-1" : map['carbos_por_grama']),
        favoriteCoffee: map['favCafe'] == 1 ? true : false,
        favoriteLunch: map['favAlmoco'] == 1 ? true : false,
        favoriteDinner: map['favJanta'] == 1 ? true : false,
        favoriteSnack: map['favLanche'] == 1 ? true : false);
  }
}
