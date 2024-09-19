import 'package:carbonet/data/models/user.dart';
import 'package:carbonet/data/repository/user_repository.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/utils/validators.dart';
import 'package:carbonet/widgets/input/date_input_field.dart';
import 'package:carbonet/widgets/buttons/gradient_button.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:carbonet/widgets/pager.dart';
import 'package:carbonet/widgets/dialogs/popup_dialog.dart';
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
      _BirthAndWeight(
        nextPage: _nextPage,
        dateController: _dateController,
        weightController: _weightController,
        onDateSelected: _handleDateSelected,
        getSelectedBirthDate: _getSelectedBirthDate,
      ),
      _HeightAndInsulin(
        heightController: _heightController,
        insulinController: _insulinController,
        registerUser: _registerUser,
      ),
    ];

    // TODO: Só pra facilitar os testes no cadastro. REMOVAM DEPOIS :V

    _emailController.text = "teste@gmail.com";
    _passwordController.text = "1231231231";
    _nameController.text = "Nome";
    _surnameController.text = "Sobrenome";
    _heightController.text = "1.79"; // minha altura :D
    _weightController.text = "71.2"; // e meu peso   :D
    // Alguém precisa pelo amor de Deus me explicar o que diabos é essa
    // constante, eu juro que não acho isso em absolutamente lugar nenhum
    // na internet pra ter um ponto de referência.
    _insulinController.text = "1.0";
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
      senha: _passwordController.text,
      peso: double.parse(_weightController.text),
      altura: double.parse(_heightController.text),
      dataNascimento: selectedBirthDate!,
      constanteInsulinica: double.parse(_insulinController.text),
      nome: _nameController.text,
      sobrenome: _surnameController.text,
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
              // LinearProgressIndicator(
              //   value: _currentProgress,
              //   minHeight: 5,
              //   borderRadius: const BorderRadius.all(Radius.circular(100)),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     IconButton(
              //       onPressed: () {
              //         infoLog("Botão de voltar");
              //         _previousPage();
              //       },
              //       icon: const Icon(
              //         Icons.arrow_back_ios_new_rounded,
              //         color: Colors.white,
              //       ),
              //     ),
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Etapa ${_currentPageIndex + 1} de ${_pageList.length}",
              //           style: const TextStyle(
              //             color: AppColors.fontDimmed,
              //           ),
              //         ),
              //         Text(
              //           _hintTexts[_currentPageIndex],
              //           style: const TextStyle(
              //             color: AppColors.fontBright,
              //           ),
              //         ),
              //       ],
              //     )
              //   ],
              // ),
              // Expanded(
              //   child: PageView(
              //     controller: _pageViewController,
              //     physics: const NeverScrollableScrollPhysics(),
              //     onPageChanged: handlePageSelected,
              //     children: _pageList,
              //   ),
              // ),
              Pager(
                pageViewController: _pageViewController,
                pages: _pageList,
                hintTexts: _hintTexts,
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
          onPressed: () {
            emailController.text = emailController.text.trim();
            if (!Validators.isValidEmail(emailController.text)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
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
                    return const PopupDialog(
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
                    return const PopupDialog(
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
                  return const PopupDialog(
                    title: "Erro ao checar email!",
                    message: "Ocorreu um erro ao checar se o seu e-mail já está registrado.",
                  );
                },
              );
              errorLog("Erro ao checar se e-mail já está cadastrado.\n");
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
          onPressed: () {
            nameController.text = nameController.text.trim();
            if (nameController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Nome inválido!",
                    message: "Por favor, insira um nome válido.",
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
                  return const PopupDialog(
                    title: "Sobrenome inválido!",
                    message: "Por favor, insira um sobrenome válido.",
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

class _BirthAndWeight extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController weightController;
  final VoidCallback nextPage;
  final Function(DateTime) onDateSelected;
  final Function getSelectedBirthDate;

  const _BirthAndWeight({
    required this.nextPage,
    required this.dateController,
    required this.weightController,
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
          onPressed: () {
            if (!Validators.isValidWeight(weightController.text)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Peso inválido!",
                    message: "Por gentileza, defina um peso válido.\nExemplo: 75.2 KG.",
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
                  return const PopupDialog(
                    title: "Data de nascimento inválida!",
                    message: "Verifique se a data inserida está correta.\nVocê precisa ter ao menos 18 anos para se registrar.",
                  );
                },
              );
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
  final Function registerUser;

  const _HeightAndInsulin({
    required this.heightController,
    required this.insulinController,
    required this.registerUser,
  });

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
          onPressed: () {
            if (heightController.text.isEmpty ||
                !Validators.isValidHeight(
                  double.parse(heightController.text),
                )) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Altura inválida!",
                    message: "Por gentileza, defina uma altura válida.",
                  );
                },
              );
              return;
            }

            if (insulinController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const PopupDialog(
                    title: "Constante inválida!",
                    message: "Por gentileza, defina uma constante insulínica válida.",
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
                  return const PopupDialog(
                    icon: Icons.check_circle_rounded,
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
                  return const PopupDialog(
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

//TODO: Coloquei isso aqui pq não sei onde mais colocar honestamente
// Talvez numa classe Utils (?)
class CommaToDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.replaceAll(',', '.'),
      selection: newValue.selection,
    );
  }
}
