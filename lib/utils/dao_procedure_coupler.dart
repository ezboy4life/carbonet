import 'package:carbonet/data/database/alimento_ingerido_dao.dart';
import 'package:carbonet/data/database/refeicao_dao.dart';
import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/refeicao.dart';

class DaoProcedureCoupler {
  static Future<int> inserirRefeicaoProcedimento(Refeicao refeicao, List<AlimentoIngerido> listaAlimentosSelecionados) async {
    int idRefeicao = await RefeicaoDAO().insertRefeicao(refeicao);

    AlimentoIngeridoDAO alimentoIngeridoDAO = AlimentoIngeridoDAO();
    for (AlimentoIngerido item in listaAlimentosSelecionados) {
      item.idRefeicao = idRefeicao;
      await alimentoIngeridoDAO.insertAlimentoIngerido(item);
    }

    return idRefeicao;
  }
}