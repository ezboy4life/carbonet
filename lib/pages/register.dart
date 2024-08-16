import 'package:carbonet/data/models/user.dart';
import 'package:carbonet/data/repository/user_repository.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/date_input_field.dart';
import 'package:carbonet/widgets/gradient_button.dart';
import 'package:carbonet/widgets/input_field.dart';
import 'package:flutter/material.dart';
import "package:carbonet/utils/app_colors.dart";
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  late PageController _pageViewController;
  late List<Widget> _pageList;
  final UserRepository userRepository = UserRepository();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _insulinController = TextEditingController();
  DateTime? selectedBirthDate;
  final TextEditingController _weightController = TextEditingController();
  final List<String> _hintTexts = [
    "Digite seu e-mail e defina um senha",
    "Digite seu nome e sobrenome",
    "Digite sua data de nascimento e seu peso",
    "Digite sua altura e sua constante insulinica",
  ];
  int _currentPageIndex = 0;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _pageList = [
      _EmailAndPassword(
        nextPage: _nextPage,
        emailController: _emailController,
        passwordController: _passwordController,
        showInvalidDialog: _showInvalidDialog,
      ),
      _NameAndSurname(
        nextPage: _nextPage,
        nameController: _nameController,
        surnameController: _surnameController,
        showInvalidDialog: _showInvalidDialog,
      ),
      _BirthAndWeight(
        nextPage: _nextPage,
        dateController: _dateController,
        weightController: _weightController,
        showInvalidDialog: _showInvalidDialog,
        onDateSelected: _handleDateSelected,
      ),
      _HeightAndInsulin(
        // nextPage: _nextPage,
        heightController: _heightController,
        insulinController: _insulinController,
        showInvalidDialog: _showInvalidDialog,
        registerUser: _registerUser,
      ),
    ];

    // TODO: Só pra facilitar os testes no cadastro. REMOVAM DEPOIS :V

    _emailController.text = "teste@gmail.com";
    _passwordController.text = "1111111111";
    _nameController.text = "Nome";
    _surnameController.text = "Sobrenome";
  }

  double _normalize(int min, int max, int value) {
    return (value - min) / (max - min);
  }

  void _nextPage() {
    _pageViewController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _previousPage() {
    _pageViewController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  //TODO: Isolar esse popup em um widget/classe separada (?)
  void _showInvalidDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(
                width: 10,
              ),
              Text(title, style: const TextStyle(color: Colors.white))
            ],
          ),
          backgroundColor: AppColors.dialogBackground,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            child: Text(message,
                style: const TextStyle(color: AppColors.fontBright)),
          ),
          actions: <Widget>[
            GradientButton(
                label: "OK",
                buttonColors: const [
                  AppColors.defaultDarkAppColor,
                  AppColors.defaultAppColor,
                ],
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  void _handlePageChanged(int currentPageIndex) {
    _currentProgress = _normalize(0, _pageList.length - 1, currentPageIndex);
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      selectedBirthDate = date;
    });
    infoLog("Data selecionada: ${selectedBirthDate.toString()}");
  }

  void _registerUser() async {
    User user = User(
      email: _emailController.text,
      senha: _passwordController.text,
      peso: double.parse(_weightController.text),
      altura: double.parse(_heightController.text),
      dataNascimento: selectedBirthDate!,
      constanteInsulinica: double.parse(_insulinController.text),
      nome: _nameController.text,
      sobrenome: _surnameController.text,
    );
    try {
      int id = await userRepository.addUser(user);
      Navigator.pop(context);
      infoLog("Usuário inserido. ID: $id");
      _showInvalidDialog(
        context,
        "Cadastro realizado!",
        "Por gentileza, faça login com os dados que você acabou de preencher.",
      );
    } catch (e) {
      errorLog("Erro ao inserir usuário no BD.\nErro: $e");
      _showInvalidDialog(
        context,
        "Erro ao realizar cadastro!",
        "Por gentileza, verifique se os dados inseridos estão corretos.\nDesrição do erro: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Oh well, play the cards that i'm given ¯\_(ツ)_/¯
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox(
          height: screenHeight * 0.6,
          width: screenWidth * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.disabled_by_default_outlined,
                color: AppColors.defaultAppColor,
                size: 130,
                weight: 800,
              ),
              const Text(
                "CarboNet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              LinearProgressIndicator(
                value: _currentProgress,
                minHeight: 5,
                borderRadius: const BorderRadius.all(Radius.circular(100)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Já possuí uma conta?",
                    style: TextStyle(color: AppColors.fontBright),
                  ),
                  TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    style: const ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: const Text(
                      "Faça o Login",
                      style: TextStyle(
                        color: AppColors.defaultBrightAppColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailAndPassword extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback nextPage;
  final Function showInvalidDialog;

  const _EmailAndPassword({
    required this.nextPage,
    required this.emailController,
    required this.passwordController,
    required this.showInvalidDialog,
  });

  bool isValidEmail(String email) {
    // Não sei se esse regex é decente mas pelos testes que fiz tá pegando
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 10;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InputField(
          controller: emailController,
          labelText: "E-mail",
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          maxLength: 320,
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: passwordController,
          labelText: "Senha",
          obscureText: true,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          maxLength: 255,
        ),
        const SizedBox(
          height: 30,
        ),
        GradientButton(
          label: "Avançar",
          buttonColors: const [
            AppColors.defaultDarkAppColor,
            AppColors.defaultAppColor,
          ],
          onPressed: () {
            emailController.text = emailController.text.trim();
            if (!isValidEmail(emailController.text)) {
              showInvalidDialog(context, "E-mail inválido!",
                  "Por gentileza, insira um endereço de e-mail válido.");
              return;
            }

            passwordController.text = passwordController.text.trim();
            if (!isValidPassword(passwordController.text)) {
              showInvalidDialog(context, "Senha inválida!",
                  "Por gentileza, insira uma senha com 10 ou mais caracteres.");
              return;
            }

            nextPage();
          },
        ),
      ],
    );
  }
}

class _NameAndSurname extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final VoidCallback nextPage;
  final Function showInvalidDialog;

  const _NameAndSurname({
    required this.nextPage,
    required this.nameController,
    required this.surnameController,
    required this.showInvalidDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InputField(
          controller: nameController,
          labelText: "Nome",
          maxLength: 255,
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: surnameController,
          labelText: "Sobrenome",
          maxLength: 255,
        ),
        const SizedBox(
          height: 30,
        ),
        GradientButton(
          label: "Avançar",
          buttonColors: const [
            AppColors.defaultDarkAppColor,
            AppColors.defaultAppColor,
          ],
          onPressed: () {
            nameController.text = nameController.text.trim();
            if (nameController.text.isEmpty) {
              showInvalidDialog(context, "Nome inválido!",
                  "Por favor, insira um nome válido.");
              return;
            }

            surnameController.text = surnameController.text.trim();
            if (surnameController.text.isEmpty) {
              showInvalidDialog(context, "Sobrenome inválido!",
                  "Por favor, insira um sobrenome válido.");
              return;
            }

            nextPage();
          },
        ),
      ],
    );
  }
}

class _BirthAndWeight extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController weightController;
  final VoidCallback nextPage;
  final Function showInvalidDialog;
  final Function(DateTime) onDateSelected;
  // final DateTime? birthDate;

  const _BirthAndWeight({
    required this.nextPage,
    required this.dateController,
    required this.weightController,
    required this.showInvalidDialog,
    required this.onDateSelected,
    // required this.birthDate,
  });

  bool isDateValid(DateTime? birthDate) {
    if (birthDate == null) {
      infoLog("Data não selecionada!");
      return false;
    }

    final currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age >= 18 && age < 122; // 122 = pessoa mais velha do mundo
  }

  bool isWeightValid(String weightString) {
    if (weightString.isEmpty) {
      return false;
    }

    double weight = double.parse(weightString);
    return weight > 0 && weight < 595; // pessoa mais pesada do mundo
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DateInputField(
          labelText: "Data de Nascimento",
          dateController: dateController,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: weightController,
          labelText: "Peso (em KG)",
          maxLength: 5,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*$')),
            CommaToDotFormatter(),
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(
          height: 30,
        ),
        GradientButton(
          label: "Avançar",
          buttonColors: const [
            AppColors.defaultDarkAppColor,
            AppColors.defaultAppColor,
          ],
          onPressed: () {
            if (!isWeightValid(weightController.text)) {
              showInvalidDialog(context, "Peso inválido!",
                  "Por gentileza, defina um peso válido.\nExemplo: 75.2 KG.");
              return;
            }
            // TODO: Implementar verificação da data selecionada
            nextPage();
          },
        ),
      ],
    );
  }
}

class _HeightAndInsulin extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController insulinController;
  final Function showInvalidDialog;
  final Function registerUser;

  const _HeightAndInsulin({
    required this.heightController,
    required this.insulinController,
    required this.showInvalidDialog,
    required this.registerUser,
  });

  bool isValidHeight(double height) {
    return height < 3;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InputField(
          controller: heightController,
          labelText: "Altura (em metros)",
          maxLength: 4,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*$')),
            CommaToDotFormatter(),
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: insulinController,
          labelText: "Constante Insulinica",
          maxLength: 5,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*$')),
            CommaToDotFormatter(),
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(
          height: 30,
        ),
        GradientButton(
          label: "Finalizar Cadastro",
          buttonColors: const [
            AppColors.defaultDarkAppColor,
            AppColors.defaultAppColor,
          ],
          onPressed: () {
            if (heightController.text.isEmpty ||
                !isValidHeight(double.parse(heightController.text))) {
              showInvalidDialog(
                context,
                "Altura inválida!",
                "Por gentileza, defina uma altura válida.",
              );
              return;
            }

            if (insulinController.text.isEmpty) {
              showInvalidDialog(
                context,
                "Constante inválida!",
                "Por gentileza, defina uma constante insulínica válida.",
              );
              return;
            }
            registerUser();
          },
        ),
      ],
    );
  }
}

//TODO: Coloquei isso aqui pq não sei onde mais colocar honestamente
// Talvez numa classe Utils (?)
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
