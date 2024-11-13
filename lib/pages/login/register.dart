import 'package:carbonet/data/models/user.dart';
import 'package:carbonet/data/repository/user_repository.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/utils/textformatters.dart';
import 'package:carbonet/utils/validators.dart';
import 'package:carbonet/widgets/input/date_input_field.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:carbonet/widgets/pager.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';
import "package:carbonet/utils/app_colors.dart";
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final PageController _pageViewController = PageController();
  late List<Widget> _pageList;
  final UserRepository userRepository = UserRepository();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _insulinController = TextEditingController();
  final TextEditingController _minBloodGlucoseController = TextEditingController();
  DateTime? selectedBirthDate;
  final TextEditingController _maxBloodGlucoseController = TextEditingController();
  final List<String> _hintTexts = [
    "Digite seu e-mail e defina uma senha",
    "Digite seu nome e sobrenome",
    "Digite sua data de nascimento e sua \nproporção de gramas de carboidratos \npor unidade de insulina",
    "Digite seu intervalo ideal de glicemia \n(limite mínimo de 70 mg/dL e máximo \nde 180 mg/dL)",
  ];

  @override
  void initState() {
    super.initState();
    _pageList = [
      _EmailAndPassword(
        nextPage: _nextPage,
        emailController: _emailController,
        passwordController: _passwordController,
        userRepository: userRepository,
      ),
      _NameAndSurname(
        nextPage: _nextPage,
        nameController: _nameController,
        surnameController: _surnameController,
      ),
      _BirthAndInsulin(
        nextPage: _nextPage,
        dateController: _dateController,
        insulinController: _insulinController,
        onDateSelected: _handleDateSelected,
        getSelectedBirthDate: _getSelectedBirthDate,
      ),
      MinAndMaxBloodGlucose(
        minBloodGlucoseController: _minBloodGlucoseController,
        maxBloodGlucoseController: _maxBloodGlucoseController,
        registerUser: _registerUser,
      ),
    ];

    // TODO Só pra facilitar os testes no cadastro. REMOVAM DEPOIS :V

    _emailController.text = "teste@gmail.com";
    _passwordController.text = "1231231231";
    _nameController.text = "Nome";
    _surnameController.text = "Sobrenome";
    _minBloodGlucoseController.text = "80"; // ex de valor mínimo dentro do intervalo
    _maxBloodGlucoseController.text = "150"; // ex de valor máximo dentro do intervalo
    // Alguém precisa pelo amor de Deus me explicar o que diabos é essa
    // constante, eu juro que não acho isso em absolutamente lugar nenhum
    // na internet pra ter um ponto de referência.
    _insulinController.text = "15";
  }

  void _nextPage() {
    _pageViewController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      selectedBirthDate = date;
    });
    infoLog("Data selecionada: ${selectedBirthDate.toString()}");
  }

  DateTime? _getSelectedBirthDate() {
    return selectedBirthDate;
  }

  void _registerUser() async {
    User user = User(
      email: _emailController.text,
      birthDate: selectedBirthDate!,
      constanteInsulinica: double.parse(_insulinController.text),
      name: _nameController.text,
      surname: _surnameController.text,
      senha: _passwordController.text,
      minBloodGlucose: int.parse(_minBloodGlucoseController.text),
      maxBloodGlucose: int.parse(_maxBloodGlucoseController.text),
    );
    int id = await userRepository.addUser(user);
    infoLog("Usuário inserido. ID: $id");
  }

  @override
  Widget build(BuildContext context) {
    // Oh well, play the cards that i'm given ¯\_(ツ)_/¯
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          // height: screenHeight * 0.6,
          // width: screenWidth * 0.9,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Image(
                  image: AssetImage("assets/imgs/logo.png"),
                  width: 96,
                  height: 96,
                  fit: BoxFit.fill,
                ),
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
              Pager(
                pageViewController: _pageViewController,
                pages: _pageList,
                hintTexts: _hintTexts,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Já possui uma conta?",
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
  final UserRepository userRepository;

  const _EmailAndPassword({
    required this.nextPage,
    required this.emailController,
    required this.passwordController,
    required this.userRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputField(
          controller: emailController,
          labelText: "E-mail",
          iconData: Icons.mail_rounded,
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
          iconData: Icons.password_rounded,
          obscureText: true,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          maxLength: 255,
        ),
        const SizedBox(
          height: 30,
        ),
        Button(
          label: "Avançar",
          onPressed: () {
            emailController.text = emailController.text.trim();
            if (!Validators.isValidEmail(emailController.text)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "E-mail inválido!",
                    message: "Por gentileza, insira um endereço de e-mail válido.",
                  );
                },
              );
              return;
            }

            Validators.checkEmailAlreadyRegistered(emailController.text).then((isEmailRegistered) {
              if (isEmailRegistered) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const WarningDialog(
                      title: "E-mail já registrado!",
                      message: "Faça o Login ou clique em \"Esqueceu sua senha?\".",
                    );
                  },
                );
                return;
              }
              infoLog("Email não registrado!");
              passwordController.text = passwordController.text.trim();
              if (!Validators.isValidPassword(passwordController.text)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const WarningDialog(
                      title: "Senha inválida!",
                      message: "Por gentileza, insira uma senha com 10 ou mais caracteres.",
                    );
                  },
                );
                return;
              }
              nextPage();
            }).catchError((error) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Erro ao checar email!",
                    message: "Ocorreu um erro ao checar se o seu e-mail já está registrado.",
                  );
                },
              );
              errorLog("Erro ao checar se e-mail já está cadastrado.\nErro: $error");
            });
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

  const _NameAndSurname({
    required this.nextPage,
    required this.nameController,
    required this.surnameController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InputField(
          controller: nameController,
          labelText: "Nome",
          iconData: Icons.person_rounded,
          maxLength: 255,
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: surnameController,
          labelText: "Sobrenome",
          iconData: Icons.person_rounded,
          maxLength: 255,
        ),
        const SizedBox(
          height: 30,
        ),
        Button(
          label: "Avançar",
          onPressed: () {
            nameController.text = nameController.text.trim();
            if (nameController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Nome inválido!",
                    message: "Por favor, insira um name válido.",
                  );
                },
              );
              return;
            }

            surnameController.text = surnameController.text.trim();
            if (surnameController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Sobrenome inválido!",
                    message: "Por favor, insira um surname válido.",
                  );
                },
              );
              return;
            }

            nextPage();
          },
        ),
      ],
    );
  }
}

class _BirthAndInsulin extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController insulinController;
  final VoidCallback nextPage;
  final Function(DateTime) onDateSelected;
  final Function getSelectedBirthDate;

  const _BirthAndInsulin({
    required this.nextPage,
    required this.dateController,
    required this.insulinController,
    required this.onDateSelected,
    required this.getSelectedBirthDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DateInputField(
          labelText: "Data de Nascimento",
          iconData: Icons.calendar_month_rounded,
          dateController: dateController,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: insulinController,
          labelText: "Constante Insulinica",
          iconData: Icons.local_hospital_rounded,
          maxLength: 5,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*$')),
            CommaToDotFormatter(),
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: false),
        ),
        const SizedBox(
          height: 30,
        ),
        Button(
          label: "Avançar",
          onPressed: () {
            if (insulinController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Proporção inválida!",
                    message: "Por gentileza, defina uma proporção insulina-carboidrato válida.",
                  );
                },
              );
              return;
            }

            DateTime? selectedBirthDate = getSelectedBirthDate();

            if (!Validators.isDateValid(selectedBirthDate)) {
              infoLog(
                "Data selecionada não é valida: ${getSelectedBirthDate().toString()}",
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Data de nascimento inválida!",
                    message: "Verifique se a data inserida está correta.\nVocê precisa ter ao menos 18 anos para se registrar.",
                  );
                },
              );
              return;
            }
            nextPage();
          },
        ),
      ],
    );
  }
}

class MinAndMaxBloodGlucose extends StatelessWidget {
  final TextEditingController minBloodGlucoseController;
  final TextEditingController maxBloodGlucoseController;
  final Function registerUser;

  const MinAndMaxBloodGlucose({
    required this.minBloodGlucoseController,
    required this.maxBloodGlucoseController,
    required this.registerUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InputField(
          controller: minBloodGlucoseController,
          labelText: "Valor mínimo do intervalo de glicemia ideal",
          iconData: Icons.local_hospital_rounded,
          maxLength: 4,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*$')),
            CommaToDotFormatter(),
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: maxBloodGlucoseController,
          labelText: "Valor máximo do intervalo de glicemia ideal",
          iconData: Icons.local_hospital_rounded,
          maxLength: 5,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*$')),
            CommaToDotFormatter(),
          ],
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(
          height: 30,
        ),
        Button(
          label: "Finalizar Cadastro",
          onPressed: () {
            if (minBloodGlucoseController.text.isEmpty || maxBloodGlucoseController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Os valores do intervalo ideal de glicemia são obrigatórios.",
                    message: "Por gentileza, preencha os campos de valores mínimo e máximo do intervalo ideal de glicose.",
                  );
                },
              );
              return;
            }

            if (!Validators.isValidMinBloodGlucose(
                int.parse(minBloodGlucoseController.text), 
                int.parse(maxBloodGlucoseController.text),
            )) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Valor mínimo inválido!",
                    message: "Por gentileza, defina um valor mínimo válido (entre 70 e 180).",
                  );
                },
              );
              return;
            }

            if (!Validators.isValidMaxBloodGlucose(
              int.parse(minBloodGlucoseController.text), 
              int.parse(maxBloodGlucoseController.text),
            )) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Valor máximo inválido!",
                    message: "Por gentileza, defina um valor máximo válido (entre 70 e 180).",
                  );
                },
              );
              return;
            }

            if (!Validators.isValidIdealBloodGlucoseInterval(
              int.parse(minBloodGlucoseController.text), 
              int.parse(maxBloodGlucoseController.text),
            )) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Intervalo ideal inválido!",
                    message: "Os valores mínimos e máximos devem estar, ao menos, a 50 mg/dL de distância entre si. Por gentileza, corrija os valores.",
                  );
                },
              );
              return;
            }

            registerUser().then((_) {
              Navigator.pop(context); // Redireciona pro Login
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    // icon: Icons.check_circle_rounded,
                    title: "Cadastro concluído!",
                    message: "Por gentileza, faça login com os dados que você inseriu.",
                  );
                },
              );
            }).catchError((error) {
              errorLog("Erro ao inserir usuário no BD.\nErro: $error");
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const WarningDialog(
                    title: "Erro ao realizar cadastro!",
                    message: "Por gentileza, revise se os dados inseridos estão corretos.",
                  );
                },
              );
            });
          },
        ),
      ],
    );
  }
}
