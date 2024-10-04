import 'package:carbonet/data/database/alimento_ingerido_dao.dart';
import 'package:carbonet/data/database/alimento_ref_dao.dart';
import 'package:carbonet/data/database/refeicao_dao.dart';
import 'package:carbonet/data/models/ingested_food.dart';
import 'package:carbonet/data/models/meal.dart';

class DaoProcedureCoupler {
  static Future<int> inserirRefeicaoProcedimento(Meal refeicao, List<IngestedFood> listaAlimentosSelecionados) async {
    int idMeal = await RefeicaoDAO().insertRefeicao(refeicao);

    AlimentoIngeridoDAO alimentoIngeridoDAO = AlimentoIngeridoDAO();
    for (IngestedFood item in listaAlimentosSelecionados) {
      item.idMeal = idMeal;
      await alimentoIngeridoDAO.insertAlimentoIngerido(item);
    }

    return idMeal;
  }

  static Future<List<IngestedFood>> getAlimentoIngeridoByRefeicaoFullData(int idMeal) async {
    AlimentoIngeridoDAO alimentoIngeridoDAO = AlimentoIngeridoDAO();
    List<IngestedFood> listaAlimentoIngerido = await alimentoIngeridoDAO.getAlimentoIngeridoByRefeicao(idMeal);

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
}
