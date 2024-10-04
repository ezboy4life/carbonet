import 'dart:async';

import 'package:carbonet/data/database/alimento_ref_dao.dart';
import 'package:carbonet/data/models/alimento_ref.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:flutter/material.dart';

enum RefeicoesEnum { cafe, almoco, jantar, lanche }


class RegistroFavoritos extends StatelessWidget {
  RegistroFavoritos({super.key});

  final Future<List<AlimentoRef>> _alimentos = AlimentoRefDAO().getAllAlimentoRef();
  final List<AlimentoRef> favoritosCafe = [];
  final List<AlimentoRef> favoritosAlmoco = [];
  final List<AlimentoRef> favoritosJantar = [];
  final List<AlimentoRef> favoritosLanche = [];
  late List<AlimentoRef> listaBase;


  Future<void> separarFavoritos() async {
    listaBase = await _alimentos;

    for (AlimentoRef alimento in listaBase) {
      alimento.favCafe ? favoritosCafe.add(alimento) : null;
      alimento.favAlmoco ? favoritosAlmoco.add(alimento) : null;
      alimento.favJanta ? favoritosJantar.add(alimento) : null;
      alimento.favLanche ? favoritosLanche.add(alimento) : null;
    }

    return;
  }

  ({List<AlimentoRef> favCafe, List<AlimentoRef> favAlmoco, List<AlimentoRef> favJanta, List<AlimentoRef> favLanche, List<AlimentoRef> listaBase}) getListas() {
    return (
      favCafe: favoritosCafe, 
      favAlmoco: favoritosAlmoco, 
      favJanta: favoritosJantar, 
      favLanche: favoritosLanche, 
      listaBase: listaBase);
  }

  void _toggleFavorito(AlimentoRef alimento, RefeicoesEnum refeicao, List<AlimentoRef> listaFav) async {

    if (listaFav.contains(alimento)) {
      listaFav.remove(alimento);
    } else {
      listaFav.add(alimento);
    }

    switch (refeicao) {
      case RefeicoesEnum.cafe:
        alimento.favCafe = !alimento.favCafe;
        break;
      case RefeicoesEnum.almoco:
        alimento.favAlmoco = !alimento.favAlmoco;
        break;
      case RefeicoesEnum.jantar:
        alimento.favJanta = !alimento.favJanta;
        break;
      case RefeicoesEnum.lanche:
        alimento.favLanche = !alimento.favLanche;
        break;
    }

    AlimentoRefDAO dao = AlimentoRefDAO();
    dao.updateStatusFavorito(alimento);

    return;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const TabBar(
          dividerColor: AppColors.fontBright,
          indicatorColor: AppColors.defaultAppColor,
          tabs: [
            Tab(
              icon: Icon(
                Icons.breakfast_dining,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Café",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.lunch_dining,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Almoço",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.dinner_dining,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Jantar",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.bakery_dining,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Lanche",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: separarFavoritos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TabBarView(
                children: [
                  ListaFavoritosRefeicao(
                    favoritos: favoritosCafe,
                    refeicao: RefeicoesEnum.cafe,
                    toggleFavorito: _toggleFavorito,
                    getListas: getListas,
                  ),
                  ListaFavoritosRefeicao(
                    favoritos: favoritosAlmoco,
                    refeicao: RefeicoesEnum.almoco,
                    toggleFavorito: _toggleFavorito,
                    getListas: getListas,
                  ),
                  ListaFavoritosRefeicao(
                    favoritos: favoritosJantar,
                    refeicao: RefeicoesEnum.jantar,
                    toggleFavorito: _toggleFavorito,
                    getListas: getListas,
                  ),
                  ListaFavoritosRefeicao(
                    favoritos: favoritosLanche,
                    refeicao: RefeicoesEnum.lanche,
                    toggleFavorito: _toggleFavorito,
                    getListas: getListas,
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}


class ListaFavoritosRefeicao extends StatefulWidget {
  const ListaFavoritosRefeicao({
    super.key,
    required this.favoritos,
    required this.refeicao,
    required this.toggleFavorito,
    required this.getListas
    });

  final List<AlimentoRef> favoritos;
  final RefeicoesEnum refeicao;
  final Function toggleFavorito;
  final Function getListas;

  @override
  State<ListaFavoritosRefeicao> createState() => _ListaFavoritosRefeicaoState();
}

class _ListaFavoritosRefeicaoState extends State<ListaFavoritosRefeicao> {

  Future<void> showAdicionarModal() async {
    await showModalBottomSheet(
      backgroundColor: Colors.grey[900],
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AdicionarFavModal(getListas: widget.getListas);
      },
    );
    if (mounted) {
      setState(() {});
    }
  }

  String getRefeicaoName(RefeicoesEnum refeicao) {
    switch (refeicao) {
      case RefeicoesEnum.cafe:
        return "Café";
      case RefeicoesEnum.almoco:
        return "Almoço";
      case RefeicoesEnum.jantar:
        return "Jantar";
      case RefeicoesEnum.lanche:
        return "Lanche";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text("Favoritos - ${getRefeicaoName(widget.refeicao)}", style: const TextStyle(color: AppColors.fontBright, fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        showAdicionarModal();
                      });
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.fontBright,
                  ),
                  label: const Text(
                    "Adicionar",
                    style: TextStyle(color: AppColors.fontBright),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.fontBright),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  )
                ),
              ]
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.favoritos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  widget.favoritos[index].nome, 
                  style: const TextStyle(color: AppColors.fontBright),
                ),
                trailing: IconButton(onPressed: () {
                    widget.toggleFavorito(widget.favoritos[index], widget.refeicao, widget.favoritos);
                    setState(() {});
                  }, 
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red)
                  ),
              );
            }
          ),
        ]
      ),
    );
  }
}


class AdicionarFavModal extends StatefulWidget {
  AdicionarFavModal({super.key, required this.getListas});

  final Function getListas;
  final TextEditingController searchBoxController = TextEditingController();

  @override
  State<AdicionarFavModal> createState() => _AdicionarFavModalState();
}

class _AdicionarFavModalState extends State<AdicionarFavModal> {
  late List<AlimentoRef> _listaBase, listaAlimentoRefFiltrada; //_favCafe, _favAlmoco, _favJanta, _favLanche
  Timer? _debounce;
  

  @override
  void initState() {
    super.initState();
    var (:favCafe, :favAlmoco, :favJanta, :favLanche, :listaBase) = widget.getListas();

    _listaBase = listaBase;
    listaAlimentoRefFiltrada = _listaBase;
  }

  void _updateListaFiltrada(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        listaAlimentoRefFiltrada = _listaBase;
      });
    } else {
      setState(() {
        listaAlimentoRefFiltrada = _listaBase.where((element) => element.nome.toLowerCase().contains(value.toLowerCase())).toList();
      });
    }
  }

  void updateFilteredList(String? searchTerm) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        _updateListaFiltrada(searchTerm);
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Editar Favoritos",
                style: TextStyle(
                  color: AppColors.fontBright,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context), 
                icon: const Icon(Icons.close, color: AppColors.fontBright),
              ),
            ],
          ),
          const SizedBox(height: 30),
          InputField(
            controller: widget.searchBoxController,
            onChanged: updateFilteredList,
            labelText: "Pesquisar por alimentos",
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: listaAlimentoRefFiltrada.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        listaAlimentoRefFiltrada[index].nome,
                        style: const TextStyle(color: AppColors.fontBright),
                      ),
                      onTap: () {
                        infoLog('"${listaAlimentoRefFiltrada[index].nome}" selecionado!');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DialogModificarFavorito(
                              alimentoSelecionado: listaAlimentoRefFiltrada[index],
                              getListas: widget.getListas,
                            );
                          },
                        );
                        setState(() {});
                      },
                    ),
                    if (index < listaAlimentoRefFiltrada.length - 1) const Divider(color: AppColors.fontDimmed),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DialogModificarFavorito extends StatefulWidget {
  const DialogModificarFavorito({
    super.key,
    required this.alimentoSelecionado,
    required this.getListas
  });

  final AlimentoRef alimentoSelecionado;
  final Function getListas;

  @override
  State<DialogModificarFavorito> createState() => _DialogModificarFavoritoState();
}

class _DialogModificarFavoritoState extends State<DialogModificarFavorito> {
  late List<AlimentoRef> _favCafe, _favAlmoco, _favJanta, _favLanche;
  late List<bool> _selectedRefeicoes;
  final List<Icon> icons = const [
    Icon(Icons.breakfast_dining),
    Icon(Icons.lunch_dining),
    Icon(Icons.dinner_dining),
    Icon(Icons.bakery_dining),
  ];

  @override
  void initState() {
    super.initState();
    var (
      :favCafe,
      :favAlmoco,
      :favJanta,
      :favLanche,
      :listaBase
    ) = widget.getListas();


    _favCafe = favCafe;
    _favAlmoco = favAlmoco;
    _favJanta = favJanta;
    _favLanche = favLanche;

    _selectedRefeicoes = [
      widget.alimentoSelecionado.favCafe, 
      widget.alimentoSelecionado.favAlmoco, 
      widget.alimentoSelecionado.favJanta, 
      widget.alimentoSelecionado.favLanche
    ];
  }

  void updateFavorito(AlimentoRef alimento, RefeicoesEnum refeicao) {
    List<AlimentoRef> listaFav;

    switch (refeicao) {
      case RefeicoesEnum.cafe:
        listaFav = _favCafe;
        alimento.favCafe = !alimento.favCafe;
        break;
      case RefeicoesEnum.almoco:
        listaFav = _favAlmoco;
        alimento.favAlmoco = !alimento.favAlmoco;
        break;
      case RefeicoesEnum.jantar:
        listaFav = _favJanta;
        alimento.favJanta = !alimento.favJanta;
        break;
      case RefeicoesEnum.lanche:
        listaFav = _favLanche;
        alimento.favLanche = !alimento.favLanche;
        break;
    }

    if (listaFav.contains(alimento)) {
      listaFav.remove(alimento);
    } else {
      listaFav.add(alimento);
    }

    AlimentoRefDAO dao = AlimentoRefDAO();
    dao.updateStatusFavorito(alimento);

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogTheme(
              elevation: 0,
            ),
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(
                color: AppColors.fontDimmed,
              ),
            ),
            backgroundColor: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 60,
                  ),
                  const SizedBox(height: 30),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Editar favorito: ${widget.alimentoSelecionado.nome}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        // All buttons are selectable.
                        _selectedRefeicoes[index] = !_selectedRefeicoes[index];
                        updateFavorito(widget.alimentoSelecionado, RefeicoesEnum.values[index]);
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: Colors.blue[700],
                    selectedColor: Colors.white,
                    fillColor: Colors.blue[200],
                    color: Colors.blue[400],
                    isSelected: _selectedRefeicoes,
                    children: icons,
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColors.fontBright),
                        borderRadius: BorderRadius.circular(24.0),
                      )
                    ),
                    child: const Text(
                      "Ok", 
                      style: TextStyle(color: AppColors.fontBright)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}