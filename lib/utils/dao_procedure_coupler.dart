import 'package:carbonet/data/database/alimento_ingerido_dao.dart';
import 'package:carbonet/data/database/alimento_ref_dao.dart';
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

  static Future<List<AlimentoIngerido>> getAlimentoIngeridoByRefeicaoFullData(int idRefeicao) async {
    AlimentoIngeridoDAO alimentoIngeridoDAO = AlimentoIngeridoDAO();
    List<AlimentoIngerido> listaAlimentoIngerido =await alimentoIngeridoDAO.getAlimentoIngeridoByRefeicao(idRefeicao);

    List<Future<void>> futures = []; // lista de futuros para serem aguardados
    // essa maracutaia de colocar todos os futuros numa lista foi cortesia do chatGPT; eu queria esse resultado, mas não tinha ctz de como conseguir

    for (AlimentoIngerido alimentoIngerido in listaAlimentoIngerido) {
      // Adiciona cada request à lista de futures; os requests já são enviados nessa fase
      futures.add(
        AlimentoRefDAO().getAlimentoById(alimentoIngerido.idAlimentoReferencia)
          .then((alimentoReferencia) {
            // Só atualiza o objeto após o futuro ser resolvido
            alimentoIngerido.alimentoReferencia = alimentoReferencia ?? alimentoIngerido.alimentoReferencia;
          }
        )
      );
    }

    // espera todos os futuros serem resolvidos
    await Future.wait(futures);

    return listaAlimentoIngerido;
  }
}