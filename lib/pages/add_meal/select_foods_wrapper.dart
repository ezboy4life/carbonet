import 'dart:async';
import 'package:carbonet/data/database/alimento_ref_dao.dart';
import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/alimento_ref.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/pages/add_meal/all_foods_list.dart';
import 'package:carbonet/pages/add_meal/favorite_foods_list.dart';
import 'package:carbonet/pages/add_meal/selected_foods_list.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';

class SelectFoods extends StatefulWidget {
  final Function setState;
  final TextEditingController searchBoxController;
  final TextEditingController favoritesSearchBoxController;
  final TextEditingController selectedFoodsSearchBoxController;
  final TextEditingController selectedMealTypeController;
  final TextEditingController glicemiaController;
  final List<AlimentoIngerido> alimentosSelecionados;
  final DateTime? mealDate;
  final TimeOfDay? mealTime;
  final Function(Refeicao) addMealToHistory;

  const SelectFoods({
    super.key,
    required this.searchBoxController,
    required this.favoritesSearchBoxController,
    required this.selectedFoodsSearchBoxController,
    required this.selectedMealTypeController,
    required this.glicemiaController,
    required this.alimentosSelecionados,
    required this.addMealToHistory,
    required this.setState,
    required this.mealDate,
    required this.mealTime,
  });

  @override
  State<SelectFoods> createState() => _SelectFoodsState();
}

class _SelectFoodsState extends State<SelectFoods> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initListAsync();
    });
  }

  Timer? _debounce;

  _initListAsync() async {
    listaAlimentoRef = await AlimentoRefDAO().getAllAlimentoRef();
    setState(() {
      listaAlimentoRefFiltrada = listaAlimentoRef;
    });
  }

  void updateFilteredList(String? value) {
    if (value == null || value.isEmpty) {
      setState(() {
        listaAlimentoRefFiltrada = listaAlimentoRef;
      });
    } else {
      setState(() {
        listaAlimentoRefFiltrada = listaAlimentoRef.where((element) => element.nome.toLowerCase().contains(value.toLowerCase())).toList();
      });
    }
  }

  void updateFilteredListDelay(String? searchTerm) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        updateFilteredList(searchTerm);
      },
    );
  }

  List<AlimentoRef> listaAlimentoRef = [];
  List<AlimentoRef> listaAlimentoRefFiltrada = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: const TabBar(
          dividerColor: AppColors.fontBright,
          indicatorColor: AppColors.defaultAppColor,
          tabs: [
            Tab(
              icon: Icon(
                Icons.restaurant_rounded,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Todos Alimentos",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.star_rounded,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Favoritos",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
            Tab(
              icon: Icon(
                Icons.check_rounded,
                color: AppColors.fontBright,
              ),
              child: Text(
                "Selecionados",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            AllFoodsList(
              filteredFoodReferenceList: listaAlimentoRefFiltrada,
              selectedFoodList: widget.alimentosSelecionados,
              searchBoxController: widget.searchBoxController,
              updateFilteredList: updateFilteredListDelay,
            ),
            FavoriteFoodsList(
              tipoRefeicao: widget.selectedMealTypeController.text,
              listaAlimentosRef: listaAlimentoRef,
              listaAlimentosSelecionados: widget.alimentosSelecionados,
            ),
            SelectedFoodsList(
              selectedFoods: widget.alimentosSelecionados,
            ),
          ],
        ),
        bottomNavigationBar: Button(
          label: "Registrar Refeição",
          onPressed: () {
            if (widget.alimentosSelecionados.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Refeição sem alimentos!",
                    message: "Insira pelo menos um alimento para que a refeição possa ser registrada.",
                  );
                },
              );
              return;
            }

            final DateTime dataRefeicao = DateTime(
              widget.mealDate!.year,
              widget.mealDate!.month,
              widget.mealDate!.day,
              widget.mealTime!.hour,
              widget.mealTime!.minute,
            );

            Refeicao refeicao = Refeicao(
              idUser: LoggedUserAccess().user!.id!,
              data: dataRefeicao,
              tipoRefeicao: widget.selectedMealTypeController.text,
              isActive: true,
            );

            DaoProcedureCoupler.inserirRefeicaoProcedimento(refeicao, widget.alimentosSelecionados).then(
              (value) {
                refeicao.id = value;
                widget.addMealToHistory(refeicao);
                Navigator.pop(context, true);
              },
            );
          },
        ),
      ),
    );
  }
}
