import 'package:carbonet/data/models/user.dart';
import 'package:carbonet/data/repository/user_repository.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/utils/validators.dart';
import 'package:carbonet/widgets/buttons/card_tile.dart';
import 'package:carbonet/widgets/dialogs/confirmation_dialog.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController emailController = TextEditingController();

  final User? user = LoggedUserAccess().user;

  void handleLogout() {
    LoggedUserAccess().user = null;
    Navigator.pop(context);
  }

  void handleEmailUpdate() {
    emailController.text.trim();

    if (!Validators.isValidEmail(emailController.text)) {
      // Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "E-mail inválido!",
            message: "Insira um e-mail válido por gentileza.",
          );
        },
      );
      return;
    }

    Validators.checkEmailAlreadyRegistered(emailController.text).then((emailIsRegistered) {
      if (emailIsRegistered) {
        // Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const WarningDialog(
              title: "E-mail já registrado!",
              message: "Esse e-mail já está registrado. Caso seja você, saia da conta atual e faça o login.",
            );
          },
        );
        return;
      }

      UserRepository userRepo = UserRepository();
      setState(() {
        user?.email = emailController.text;
      });

      if (user != null) {
        userRepo.updateUserEmail(user!);
      }
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "E-mail alterado com sucesso",
            message: "Seu e-mail foi alterado com sucesso!",
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            // shrinkWrap: true,
            children: [
              const Icon(
                Icons.circle,
                color: Colors.grey,
                size: 108,
              ),
              const SizedBox(height: 8),
              /* Nome e sobrenome */
              Text(
                "${user?.name} ${user?.surname}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Text(
                "${user?.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              /* Dados relacionados ao usuário */
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    const CardTile(
                      title: "Nome e sobrenome",
                      icon: Icons.person,
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    CardTile(
                      title: "Data de nascimento",
                      icon: Icons.calendar_month_rounded,
                      onTap: () async {},
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    CardTile(
                      title: "Email",
                      icon: Icons.email,
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InputDialog(
                              controller: emailController,
                              title: "Alterar email",
                              message: const [
                                TextSpan(
                                  text: "Insira o seu novo email:",
                                  style: TextStyle(color: AppColors.fontBright),
                                ),
                              ],
                              label: "Email",
                              buttonLabel: "Alterar",
                              keyboardType: TextInputType.emailAddress,
                              onPressed: () {
                                handleEmailUpdate();
                              },
                            );
                          },
                        );
                      },
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    const CardTile(
                      title: "Senha",
                      icon: Icons.key,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              /* Dados relacionados à saúde */
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    const CardTile(
                      title: "Glicemia mínima e máxima",
                      icon: Icons.health_and_safety_rounded,
                      iconBackgroundColor: Colors.blue,
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    const CardTile(
                      title: "Constante insulínica",
                      icon: Icons.calendar_month_rounded,
                      iconBackgroundColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  title: const Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sair", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () async {
                    bool? logoff = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return const ConfirmationDialog(
                          title: "Sair",
                          message: "Você tem certeza que deseja sair de sua conta?",
                          confirmButtonLabel: "Sair",
                          confirmButtonColor: Colors.red,
                        );
                      },
                    );

                    if (logoff != null && logoff && context.mounted) {
                      handleLogout();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
