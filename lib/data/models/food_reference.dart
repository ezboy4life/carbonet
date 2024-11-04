// nota: esse modelo é um mix de duas tabelas. ele serve para tanto definir os alimentos de referência, como para definir se X alimento é um favorito para uma refeição Y.

// quando eu puxo uma entrada da tabela foodReference, todos os campos menos o "qtd_ingerida" são setados; nessa brincadeira, quando eu puxar os valores de alimentoFreq, ocorre uma coisa terrivelmente feia para mapear os favoritos. infelizmente a alternativa seria manter uma tabela de alimentos em que constasse a configuração de favoritos para cada usuário, então por ora vai ficar a loucura mesmo.

// quando eu crio um alimentoIngerido para usar na lista de alimentos selecionados, vai tanto o id desse alimento (que é salva no bd), quanto uma referência interna para esse objeto todo (que não é salva no bd).

class FoodReference {
  final int id;
  final String name;
  final String portion;
  final double gramsPerPortion;
  final double carbsPerPortion;
  final double caloriesPerPortion;

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
      required this.caloriesPerPortion,
      this.favoriteCoffee = false,
      this.favoriteLunch = false,
      this.favoriteDinner = false,
      this.favoriteSnack = false});

  /// Até onde eu sei, isso só é um fallback para um getter específico quando o foodReference setado nele for nulo, para evitar uma exception. Talvez algo a ser removido depois.
  static FoodReference fromId(int id) {
    // usar o DAO para buscar essa instância do alimento na db
    return FoodReference(id: 0, name: "ERROR", portion: "ERROR", gramsPerPortion: 0, carbsPerPortion: 0, caloriesPerPortion: 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': name,
      'porcao': portion,
      'gramasPorPorcao': gramsPerPortion,
      'carbosPorPorcao': carbsPerPortion,
      'caloriasPorPorcao': caloriesPerPortion,
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
        gramsPerPortion: double.parse(map['gramasPorPorcao'] == "-" ? "-1" : map['gramasPorPorcao']),
        carbsPerPortion: double.parse(map['carbosPorPorcao'] == "-" ? "-1" : map['carbosPorPorcao']),
        caloriesPerPortion: double.parse(map['caloriasPorPorcao'] == "-" ? "-1" : map['caloriasPorPorcao']),
        favoriteCoffee: map['favCafe'] == 1 ? true : false,
        favoriteLunch: map['favAlmoco'] == 1 ? true : false,
        favoriteDinner: map['favJanta'] == 1 ? true : false,
        favoriteSnack: map['favLanche'] == 1 ? true : false);
  }
}
