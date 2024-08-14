import 'package:carbonet/pages/register.dart';
import "package:carbonet/utils/app_colors.dart";
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/input_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                  Container(
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      shape: StadiumBorder(),
                      // color: AppColors.defaultAppColor,
                      // TODO: Com gradiente ou sem (?)
                      gradient: LinearGradient(
                        colors: [
                          AppColors.defaultDarkAppColor,
                          AppColors.defaultAppColor,
                        ],
                      ),
                    ),
                    child: TextButton(
                      style: const ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {
                        //TODO: Implementar botão 'Entrar'
                        infoLog("Botão 'Entrar'");
                      },
                      child: const Text(
                        "Entrar",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
