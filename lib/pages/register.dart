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
          height: 325,
          width: 325,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: _currentProgress,
                minHeight: 5,
                borderRadius: BorderRadius.all(Radius.circular(100)),
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

class _EmailAndPassword extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VoidCallback nextPage;

  _EmailAndPassword({
    required this.nextPage,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InputField(
            controller: emailController,
            labelText: "E-mail",
            obscureText: false,
          ),
          const SizedBox(
            height: 30,
          ),
          InputField(
            controller: passwordController,
            labelText: "Senha",
            obscureText: true,
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
            onPressed: nextPage,
          ),
        ],
      ),
    );
  }
}
