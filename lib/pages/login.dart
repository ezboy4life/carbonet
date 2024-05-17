import 'package:carbonet/assets/app_colors.dart';
import 'package:carbonet/utils/logger.dart';
import 'package:carbonet/widgets/input_field.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.disabled_by_default_outlined,
              color: AppColors.defaultBlue,
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
                children: [
                  InputField(
                    controller: emailController,
                    labelText: "E-mail",
                    obscureText: false,
                  ),
                  InputField(
                    controller: passwordController,
                    labelText: "Senha",
                    obscureText: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
