import 'package:carbonet/data/database/database_helper.dart';
import 'package:carbonet/data/database/ingested_food_dao.dart';
import 'package:carbonet/data/database/food_reference_dao.dart';
import 'package:carbonet/data/database/meal_dao.dart';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/data/models/meal.dart';

class DaoProcedureCoupler {
  static Future<int> inserirRefeicaoProcedimento(Meal refeicao, List<IngestedFood> listaAlimentosSelecionados) async {
    int idMeal = await MealDAO().insertMeal(refeicao);

    IngestedFoodDAO alimentoIngeridoDAO = IngestedFoodDAO();
    for (IngestedFood item in listaAlimentosSelecionados) {
      item.idMeal = idMeal;
      await alimentoIngeridoDAO.insertIngestedFood(item);
    }

    return idMeal;
  }

  static Future<List<IngestedFood>> getAlimentoIngeridoByRefeicaoFullData(int idMeal) async {
    IngestedFoodDAO alimentoIngeridoDAO = IngestedFoodDAO();
    List<IngestedFood> listaAlimentoIngerido = await alimentoIngeridoDAO.getIngestedFoodByMealId(idMeal);

    List<Future<void>> futures = []; // lista de futuros para serem aguardados
    // essa maracutaia de colocar todos os futuros numa lista foi cortesia do chatGPT; eu queria esse resultado, mas não tinha ctz de como conseguir

    for (IngestedFood alimentoIngerido in listaAlimentoIngerido) {
      // Adiciona cada request à lista de futures; os requests já são enviados nessa fase
      futures.add(FoodReferenceDAO().getAlimentoById(alimentoIngerido.idFoodReference).then((foodReference) {
        // Só atualiza o objeto após o futuro ser resolvido
        alimentoIngerido.foodReference = foodReference ?? alimentoIngerido.foodReference;
      }));
    }

    // espera todos os futuros serem resolvidos
    await Future.wait(futures);

    return listaAlimentoIngerido;
  }

  static Future<void> removerRefeicaoProcedimento(Meal refeicao) async {
    var db = await DatabaseHelper().database;

    await db.delete('alimento_ingerido', where: 'idRefeicao = ?', whereArgs: [refeicao.id]);

    await db.delete('refeicao', where: 'id = ?', whereArgs: [refeicao.id]);
  }
}
