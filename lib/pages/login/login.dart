import 'package:carbonet/data/database/database_helper.dart';
import 'package:carbonet/data/models/user.dart';
import 'package:carbonet/data/repository/user_repository.dart';
import "package:carbonet/utils/app_colors.dart";
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/input/input_field.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  UserRepository userRepository = UserRepository();

  void login(String email, String password) async {
    User? user = await userRepository.fetchUserFromLogin(email, password);

    if (!mounted) {
      return;
    }

    if (user != null) {
      // TODO pra ser sincero isso aqui é um hack bem meia boca mas é o que tem pra hoje 😇
      LoggedUserAccess().user = user;
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.of(context).pushNamed("/home");
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WarningDialog(
          title: "Usuário não encontrado!",
          message: "Verifique se o e-mail e senha estão corretos.",
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Só pra facilitar minha vida 1 cadinho tá bom ;v
    emailController.text = "teste@gmail.com";
    passwordController.text = "1231231231";
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(
              image: AssetImage("assets/imgs/logo.png"),
              width: 130,
              height: 130,
              fit: BoxFit.fill,
            ),
            const Text(
              "CarboNet",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  InputField(
                    controller: emailController,
                    labelText: "E-mail",
                    iconData: Icons.email_rounded,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(" "),
                    ],
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
                      FilteringTextInputFormatter.deny(" "),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      //TODO: Implementar botão 'Esqueceu sua senha?'
                      infoLog("Botão 'Esqueceu sua senha?'");
                    },
                    style: const ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Esqueceu sua senha?",
                        style: TextStyle(color: AppColors.fontBright),
                      ),
                    ),
                  ),
                  Button(
                    label: "Entrar",
                    onPressed: () {
                      emailController.text = emailController.text.trim();
                      passwordController.text = passwordController.text.trim();
                      login(emailController.text, passwordController.text);
                      infoLog("Botão 'Entrar'");
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "ou entre com",
                    style: TextStyle(color: AppColors.defaultBrightAppColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          color: AppColors.fontDark,
                          shape: BoxShape.circle,
                        ),
                        child: const Image(
                          image: AssetImage("assets/imgs/facebook_logo.png"),
                          width: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: const BoxDecoration(
                          color: AppColors.fontDark,
                          shape: BoxShape.circle,
                        ),
                        child: const Image(
                          image: AssetImage("assets/imgs/google_logo.png"),
                          width: 23,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          color: AppColors.fontDark,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.apple,
                          color: Colors.white,
                          size: 27,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Não tem uma conta?",
                        style: TextStyle(color: AppColors.fontBright),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pushNamed("/register");
                          passwordController.text = emailController.text = "";
                        },
                        style: const ButtonStyle(
                          splashFactory: NoSplash.splashFactory,
                        ),
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Cadastre-se",
                            style: TextStyle(
                              color: AppColors.defaultBrightAppColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Botãozinho maroto para recriar o banco de dados 🤗
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: IconButton(
          onPressed: () {
            showDialog(
              context: context, 
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Recriar o banco de dados'),
                content: const Text('Tem certeza que deseja recriar o banco de dados?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      DatabaseHelper().recreateDatabase();
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.error
                    ),
                    child: const Text('Recriar'),
                  ),
                ],
              ));
          }, 
          icon: const Icon(Icons.refresh),
          color: Colors.white,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
        ),
    );
  }
}
