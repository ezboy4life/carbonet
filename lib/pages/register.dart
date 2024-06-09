import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/gradient_button.dart';
import 'package:carbonet/widgets/input_field.dart';
import 'package:flutter/material.dart';
import "package:carbonet/utils/app_colors.dart";

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
  final List<String> _hintTexts = [
    "Texto 1",
    "Texto 2",
    "Texto 3",
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
      ),
      const Text(
        "Página 2",
        style: TextStyle(color: Colors.white),
      )
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

  void _handlePageChanged(int currentPageIndex) {
    _currentProgress = _normalize(0, _pageList.length - 1, currentPageIndex);
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SizedBox(
          width: 325,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.apple,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(
                height: 10,
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
                  // physics: const NeverScrollableScrollPhysics(),
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

class _EmailAndPassword extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback nextPage;

  _EmailAndPassword({
    required this.nextPage,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<_EmailAndPassword> createState() => _EmailAndPasswordState();
}

class _EmailAndPasswordState extends State<_EmailAndPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLengthValid = false, hasNumberOrSymbol = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InputField(
            controller: widget.emailController,
            labelText: "E-mail",
            obscureText: false,
          ),
          const SizedBox(
            height: 30,
          ),
          InputField(
            controller: widget.passwordController,
            labelText: "Senha",
            obscureText: true,
          ),
          const SizedBox(
            height: 30,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "A senha deve ter",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.circle_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Um caractere especial (# ? ! &)",
                style: TextStyle(color: AppColors.fontBright),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.circle_outlined,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "10 caracteres",
                style: TextStyle(color: AppColors.fontBright),
              )
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
            onPressed: widget.nextPage,
          ),
        ],
      ),
    );
  }
}
