// Nota: A página está inteirinha sem estilos.
// Isso é intencional, por enquanto a prioridade é fazer funcionar.
// Reposta a nota: IUPIII! :3

import 'package:carbonet/data/models/alimento_ingerido.dart';
import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/pages/selecionar_alimentos.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/dao_procedure_coupler.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/utils/validators.dart';
import 'package:carbonet/widgets/date_input_field.dart';
import 'package:carbonet/widgets/dropdown_menu.dart';
import 'package:carbonet/widgets/dropdown_menu_entry.dart';
import 'package:carbonet/widgets/gradient_button.dart';
import 'package:carbonet/widgets/popup_dialog.dart';
import 'package:carbonet/widgets/time_input_field.dart';
import 'package:carbonet/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdicionarRefeicao extends StatefulWidget {
  const AdicionarRefeicao({super.key});

  @override
  State<AdicionarRefeicao> createState() => _AdicionarRefeicaoState();
}

class _AdicionarRefeicaoState extends State<AdicionarRefeicao> {
  final List<AlimentoIngerido> alimentosSelecionados = [];
  final TextEditingController selecionarAlimentosController =
      TextEditingController();
  final TextEditingController tipoRefeicaoController = TextEditingController();
  final TextEditingController _glicemiaController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _selectedMealTypeController =
      TextEditingController();
  // final List<AlimentoIngerido> _selectedFoods
  DateTime? selectedMealDate;
  TimeOfDay? selectedMealTime;

  final List<String> _hintTexts = [
    "Preencha os dados",
    "Selecione os alimentos",
  ];
  late List<Widget> _pageList;
  final PageController _pageViewController = PageController();
  double glicemia = 0.0;
  double totalCHO = 0.0;
  double _currentProgress = 0.0;
  int _currentPageIndex = 0;

  final List<DropdownMenuEntry<String>> _tiposDeRefeicao = [
    CustomDropdownMenuEntry(value: "Café da manhã", label: "Café da manhã"),
    CustomDropdownMenuEntry(value: "Almoço", label: "Almoço"),
    CustomDropdownMenuEntry(value: "Janta", label: "Janta"),
    CustomDropdownMenuEntry(value: "Lanche", label: "Lanche"),
  ];

  double _normalize(int min, int max, int value) {
    return (value - min) / (max - min);
  }

  void _handlePageChanged(int currentPageIndex) {
    _currentProgress = _normalize(0, _pageList.length - 1, currentPageIndex);
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _nextPage() {
    FocusScope.of(context).unfocus();
    _pageViewController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _previousPage() {
    _selectedMealTypeController.text = "";
    _glicemiaController.text = "";

    _pageViewController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      selectedMealDate = date;
      String day = date.day.toString().padLeft(2, "0");
      String month = date.month.toString().padLeft(2, "0");
      _dateController.text = "$day/$month/${date.year}";
    });
    // infoLog("Data selecionada: ${selectedMealDate.toString()}");
  }

  void _handleTimeSelected(TimeOfDay time) {
    setState(() {
      selectedMealTime = time;
      String hour = time.hour.toString().padLeft(2, "0");
      String minutes = time.minute.toString().padLeft(2, "0");

      _timeController.text = "$hour:$minutes";
    });
    // infoLog("Horário selecionado: ${_timeController.text}");
  }

  DateTime? _getSelectedDate() {
    return selectedMealDate;
  }

  TimeOfDay? _getSelectedTime() {
    return selectedMealTime;
  }

  @override
  void initState() {
    super.initState();
    _pageList = [
      MealInfo(
        nextPage: _nextPage,
        onDateSelected: _handleDateSelected,
        onTimeSelected: _handleTimeSelected,
        getSelectedDate: _getSelectedDate,
        getSelectedTime: _getSelectedTime,
        glicemiaController: _glicemiaController,
        dateController: _dateController,
        timeController: _timeController,
        selectedMealTypeController: _selectedMealTypeController,
        tiposDeRefeicao: _tiposDeRefeicao,
      ),
      DialogSelecionarAlimento(
          searchBoxController: selecionarAlimentosController,
          alimentosSelecionados: alimentosSelecionados,
          setState: setState)
    ];
    _handleDateSelected(DateTime.now());
    _handleTimeSelected(TimeOfDay.now());
  }

  @override
  void setState(VoidCallback fn) {
    totalCHO = 0;
    for (var alimentoIngerido in alimentosSelecionados) {
      totalCHO += alimentoIngerido.alimentoReferencia.carbos_por_grama *
          alimentoIngerido.qtdIngerida;
    }
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close_rounded,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          // height: screenHeight * 1,
          // width: screenWidth * 1,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: _currentProgress,
                minHeight: 5,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                color: AppColors.defaultAppColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      infoLog("Botão de voltar");
                      _previousPage();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Etapa ${_currentPageIndex + 1} de ${_pageList.length}",
                        style: const TextStyle(
                          color: AppColors.fontDimmed,
                        ),
                      ),
                      Text(
                        _hintTexts[_currentPageIndex],
                        style: const TextStyle(
                          color: AppColors.fontBright,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pageViewController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: _handlePageChanged,
                  children: _pageList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealInfo extends StatelessWidget {
  final VoidCallback nextPage;
  final Function(DateTime) onDateSelected;
  final Function(TimeOfDay) onTimeSelected;
  final Function getSelectedDate;
  final Function getSelectedTime;
  final TextEditingController glicemiaController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final TextEditingController selectedMealTypeController;
  final List<DropdownMenuEntry<String>> tiposDeRefeicao;

  const MealInfo({
    super.key,
    required this.nextPage,
    required this.onDateSelected,
    required this.onTimeSelected,
    required this.getSelectedDate,
    required this.getSelectedTime,
    required this.glicemiaController,
    required this.dateController,
    required this.timeController,
    required this.selectedMealTypeController,
    required this.tiposDeRefeicao,
  });

  void _handleSelectedMealType(Object? object) {
    if (object == null) {
      return;
    }
    selectedMealTypeController.text = object.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        DateInputField(
          labelText: "Data da refeição",
          dateController: dateController,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(
          height: 30,
        ),
        TimeInputField(
          labelText: "Horário da refeição",
          timeController: timeController,
          onTimeSelected: onTimeSelected,
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: glicemiaController,
          labelText: "Glicemia",
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d*[.,]?\d*$'),
            ),
            CommaToDotFormatter(),
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          maxLength: 320,
        ),
        const SizedBox(
          height: 30,
        ),
        CustomDropDownMenu(
          labelText: "Tipo da Refeição",
          dropdownMenuEntries: tiposDeRefeicao,
          selectedDropdownMenuEntry: CustomDropdownMenuEntry(
            value: selectedMealTypeController.text,
            label: selectedMealTypeController.text,
          ),
          onSelected: _handleSelectedMealType,
        ),
        // const SizedBox(
        //   height: 30,
        // ),
        Spacer(),
        GradientButton(
          label: "Avançar",
          buttonColors: const [
            AppColors.defaultDarkAppColor,
            AppColors.defaultAppColor,
          ],
          onPressed: () {
            // Validação da data
            DateTime? date = getSelectedDate();

            if (date == null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Data inválida!",
                    message: "Por gentileza, defina uma data válida.",
                  );
                },
              );
              return;
            }

            // Validação do horário
            TimeOfDay? time = getSelectedTime();
            if (!Validators.isTimeValid(time)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Horário inválido!",
                    message: "Por gentileza, defina um horário válido.",
                  );
                },
              );
              return;
            }

            // Validação da Glicemia
            if (glicemiaController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Glicemia inválida!",
                    message: "Por gentileza, defina um valor válido.",
                  );
                },
              );
              return;
            }

            // Validação do tipo da refeição
            if (selectedMealTypeController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Tipo de refeição inválido!",
                    message: "Por gentileza, selecione valor válido.",
                  );
                },
              );
              return;
            }

            nextPage();
          },
        )
      ],
    );
  }
}

class MealList extends StatelessWidget {
  final List<AlimentoIngerido> selectedFoods;

  const MealList({
    super.key,
    required this.selectedFoods,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      decoration: BoxDecoration(color: Colors.white),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: selectedFoods.length,
        itemBuilder: (context, index) {
          final alimento = selectedFoods[index];
          return ListTile(
            title: Text(alimento.alimentoReferencia.nome),
            trailing: Text("${alimento.qtdIngerida}g"),
          );
        },
      ),
    );
  }
}

/// O botão responsável pelos eventos de cadastrar uma refeição.
///
/// Entenda-se por isso: criar o objeto refeição, colocar a lista de alimentos selecionados dentro dele, chamar o sequenciador que invoca os DAOs responsáveis por cadastrar a refeição (e, em seguida, os alimentos ingeridos) e, ao final, devolver você para a tela inicial com uma notificação snackbar de sucesso.
class TextButton_CadastrarRefeicao extends StatelessWidget {
  const TextButton_CadastrarRefeicao({
    super.key,
    required this.alimentosSelecionados,
    required this.glicemia,
    required this.totalCHO,
    required this.tipoRefeicao,
  });

  final List<AlimentoIngerido> alimentosSelecionados;
  final double glicemia;
  final double totalCHO;
  final String tipoRefeicao;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      label: const Text("Concluir"),
      icon: const Icon(Icons.check, color: Colors.white),
      onPressed: () {
        if (tipoRefeicao.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Selecione o tipo de refeição."),
            ),
          );
          return;
        } else {
          Refeicao refeicao = Refeicao(
            idUser: LoggedUserAccess().user!.id!,
            data: DateTime
                .now(), // TODO mudar <- tem que ter um campo pra selecionar data aqui tipo o que tem na tela de cadastro :)
            tipoRefeicao: tipoRefeicao,
            isActive: true,
          );

          DaoProcedureCoupler.inserirRefeicaoProcedimento(
                  refeicao, alimentosSelecionados)
              .then(
            (value) {
              //TODO
              //se sucesso, devolver o valor pra tela home e mostrar uma snackbar de sucesso;
              Navigator.pop(context, true);
              //se falha, mostrar uma snackbar de erro e ficar nessa página, para o usuário poder tentar de novo.
            },
          );
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: AppColors.defaultGreen,
        foregroundColor: Colors.white,
      ),
    );
  }
}

/// A lista de alimentos selecionados.
///
/// Não tem muito mais o que dizer, é só a lista dos alimentos selecionados com as quantidades (alimentoIngerido)
class ListView_AlimentosSelecionados extends StatelessWidget {
  const ListView_AlimentosSelecionados({
    super.key,
    required this.alimentosSelecionados,
  });
  final List<AlimentoIngerido> alimentosSelecionados;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: alimentosSelecionados.length,
      itemBuilder: (context, index) {
        final alimento = alimentosSelecionados[index];
        return ListTile(
          title: Text(alimento.alimentoReferencia.nome),
          trailing: Text("${alimento.qtdIngerida}g"),
        );
      },
    );
  }
}

/// O botão responsável por abrir a página de busca de alimentos.
///
/// Quase certeza que aqui a gente precisa passar a lista de alimentos selecionados, pra ela ser alterada por referência.
class TextButton_BuscarAlimentos extends StatelessWidget {
  const TextButton_BuscarAlimentos({
    super.key,
    required this.alimentosSelecionados,
    required this.setPageState,
  });
  final List<AlimentoIngerido> alimentosSelecionados;
  final Function setPageState;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        icon: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        label: const Text('Buscar...'),
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  final TextEditingController textController =
                      TextEditingController();
                  return DialogSelecionarAlimento(
                    searchBoxController: textController,
                    alimentosSelecionados: alimentosSelecionados,
                    setState: setState,
                  );
                },
              );
            },
          ).then(
            (value) {
              setPageState(() {});
            },
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: AppColors.defaultAppColor,
          foregroundColor: Colors.white,
        ));
  }
}

class CommaToDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.replaceAll(',', '.'),
      selection: newValue.selection,
    );
  }
}
