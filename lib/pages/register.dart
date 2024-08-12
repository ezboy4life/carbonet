import 'package:carbonet/utils/logger.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final List<String> _hintTexts = [
    "Digite seu e-mail e defina um senha",
    "Digite seu nome e sobrenome",
    "Digite sua data de nascimento e seu peso",
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
        showInvalidDialog: _showInvalidDialog
      ),
      _HealthInfo()
    ];
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
          content: Text(message, style: const TextStyle(color: AppColors.fontBright)),
          actions: <Widget>[
            GradientButton(
              label: "OK", 
              buttonColors: const [
                AppColors.defaultDarkAppColor,
                AppColors.defaultAppColor,
              ], 
              onPressed: () {
                Navigator.pop(context);
              }
            )
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
                        
                  const Text("Já possuí uma conta?", style: TextStyle(color: AppColors.fontBright),),
                  TextButton(
                    onPressed: () => {
                      Navigator.pop(context)
                    },
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
    required this.showInvalidDialog
  });

  bool isValidEmail(String email) {
    // Não sei se esse regex é decente mas pelos testes que fiz tá pegando
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
          obscureText: false,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
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
              showInvalidDialog(
                context,
                "E-mail inválido!",
                "Por favor, insira um endereço de e-mail válido."
              );
              return;
            }

            passwordController.text = passwordController.text.trim();
            if (!isValidPassword(passwordController.text)) {
              showInvalidDialog(
                context,
                "Senha inválida!",
                "Por favor, insira uma senha com mais de 10 caracteres."
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

class _NameAndSurname extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final VoidCallback nextPage;
  final Function showInvalidDialog; 


  const _NameAndSurname({
    required this.nextPage,
    required this.nameController,
    required this.surnameController,
    required this.showInvalidDialog
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InputField(
          controller: nameController,
          labelText: "Nome",
          obscureText: false,
        ),
        const SizedBox(
          height: 30,
        ),
        InputField(
          controller: surnameController,
          labelText: "Sobrenome",
          obscureText: false,
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
              showInvalidDialog(
                context,
                "Nome inválido!",
                "Por favor, insira um nome válido."
              );
              return;
            }

            surnameController.text = surnameController.text.trim();
            if (surnameController.text.isEmpty) {
              showInvalidDialog(
                context,
                "Sobrenome inválido!",
                "Por favor, insira um sobrenome válido."
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

class _HealthInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("implementar + coisas aqui ;3"));
  }
}
