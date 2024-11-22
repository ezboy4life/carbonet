import 'package:carbonet/data/models/user.dart';
import 'package:carbonet/data/repository/user_repository.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/utils/textformatters.dart';
import 'package:carbonet/utils/validators.dart';
import 'package:carbonet/widgets/buttons/button.dart';
import 'package:carbonet/widgets/buttons/card_tile.dart';
import 'package:carbonet/widgets/dialogs/confirmation_dialog.dart';
import 'package:carbonet/widgets/dialogs/input_dialog.dart';
import 'package:carbonet/widgets/dialogs/warning_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController minBloodGlucoseController = TextEditingController();
  final TextEditingController maxBloodGlucoseController = TextEditingController();
  final TextEditingController insulinController = TextEditingController();

  final User? user = LoggedUserAccess().user;

  void handleNameUpdate() {
    nameController.text.trim();

    UserRepository userRepo = UserRepository();
    setState(() {
      user?.name = nameController.text;
    });

    if (user != null) {
      userRepo.updateUserName(user!);
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Nome alterado com sucesso!",
            message: "Seu nome foi alterado com sucesso.",
          );
        },
      );
    }
  }

  void handleSurnameUpdate() {
    surnameController.text.trim();

    UserRepository userRepo = UserRepository();
    setState(() {
      user?.surname = surnameController.text;
    });

    if (user != null) {
      userRepo.updateUserSurname(user!);
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Sobrenome alterado com sucesso!",
            message: "Seu sobrenome foi alterado com sucesso.",
          );
        },
      );
    }
  }

  void handleBirthdateUpdate(DateTime? newBirthdate) {
    if (newBirthdate == null) {
      return;
    }

    user!.birthDate = newBirthdate;
    UserRepository().updateUserBirthDate(user!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WarningDialog(
          title: "Data de nascimento alterada com sucesso!",
          message: "Seu aniversário foi alterado com sucesso.",
        );
      },
    );
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
            title: "E-mail alterado com sucesso!",
            message: "Seu e-mail foi alterado com sucesso.",
          );
        },
      );
      emailController.text = "";
    });
  }

  void handlePasswordUpdate() {
    passwordController.text.trim();

    if (!Validators.isValidPassword(passwordController.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Senha inválida!",
            message: "Insira uma senha válida por gentileza.",
          );
        },
      );
      return;
    }

    if (user != null) {
      user?.passwordHash = User.hashPassword(passwordController.text);
      UserRepository().updateUserPassword(user!);
      passwordController.text = "";

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Senha alterada com sucesso!",
            message: "Sua senha foi alterada com sucesso.",
          );
        },
      );
    }
  }

  void handleInsulinUpdate() {
    insulinController.text.trim();
//  TODO: Implementar validação pra isso aq (?)
    if (user != null) {
      user?.constanteInsulinica = double.parse(insulinController.text);
      UserRepository().updateUserInsulin(user!);

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Constante insulínica alterada com sucesso!",
            message: "Sua constante insulínica foi alterada com sucesso.",
          );
        },
      );
    }
  }

  void handleMaxBloodGlucoseUpdate() {
    if (user == null) {
      return;
    }

    maxBloodGlucoseController.text.trim();

    if (!Validators.isValidMaxBloodGlucose(user!.minBloodGlucose, int.parse(maxBloodGlucoseController.text))) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Valor inválido!",
            message: "Por gentileza, insira um valor para a glicemia máxima válida.",
          );
        },
      );
      return;
    }

    user?.maxBloodGlucose = int.parse(maxBloodGlucoseController.text);
    UserRepository().updateUserMaxBloodGlucose(user!);

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WarningDialog(
          title: "Glicemia máxima alterada com sucesso!",
          message: "Sua glicemia máxima foi alterada com sucesso.",
        );
      },
    );
  }

  void handleMinBloodGlucoseUpdate() {
    if (user == null) {
      return;
    }

    minBloodGlucoseController.text.trim();

    if (!Validators.isValidMinBloodGlucose(int.parse(minBloodGlucoseController.text), user!.maxBloodGlucose)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const WarningDialog(
            title: "Valor inválido!",
            message: "Por gentileza, insira um valor para a glicemia mínima válida.",
          );
        },
      );
      return;
    }

    user?.minBloodGlucose = int.parse(minBloodGlucoseController.text);
    UserRepository().updateUserMinBloodGlucose(user!);

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const WarningDialog(
          title: "Glicemia mínima alterada com sucesso!",
          message: "Sua glicemia mínima foi alterada com sucesso.",
        );
      },
    );
  }

  void handleLogout() {
    LoggedUserAccess().user = null;
    Navigator.pop(context);
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
              /* Foto? De momento n tem campo pra guardar a URL de cada user ent fica assim mesmo fodase*/
              Container(
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6C34A9h7J-M78xVt0Nc0EGEbTTvypaWlOMQ&s'),
                    fit: BoxFit.contain,
                  ),
                ),
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
                    CardTile(
                      title: "Nome",
                      icon: Icons.person,
                      onTap: () {
                        if (user != null) {
                          nameController.text = user!.name;
                        }

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InputDialog(
                              controller: nameController,
                              title: "Alterar nome",
                              message: const [
                                TextSpan(
                                  text: "Insira o seu novo nome:",
                                  style: TextStyle(color: AppColors.fontBright),
                                ),
                              ],
                              label: "Nome",
                              buttonLabel: "Alterar",
                              keyboardType: TextInputType.name,
                              onPressed: handleNameUpdate,
                            );
                          },
                        );
                      },
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    CardTile(
                      title: "Sobrenome",
                      icon: Icons.person,
                      onTap: () {
                        if (user != null) {
                          surnameController.text = user!.surname;
                        }

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InputDialog(
                              controller: surnameController,
                              title: "Alterar sobrenome",
                              message: const [
                                TextSpan(
                                  text: "Insira o seu novo sobrenome:",
                                  style: TextStyle(color: AppColors.fontBright),
                                ),
                              ],
                              label: "Sobrenome",
                              buttonLabel: "Alterar",
                              keyboardType: TextInputType.name,
                              onPressed: handleSurnameUpdate,
                            );
                          },
                        );
                      },
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    CardTile(
                      title: "Data de nascimento",
                      icon: Icons.calendar_month_rounded,
                      onTap: () async {
                        if (user == null) {
                          return;
                        }

                        DateTime userBirthdate = user!.birthDate;

                        DateTime? newBirthdate = await showDatePicker(
                          context: context,
                          initialDate: userBirthdate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        handleBirthdateUpdate(newBirthdate);
                      },
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    CardTile(
                      title: "Email",
                      icon: Icons.email,
                      onTap: () {
                        if (user != null) {
                          emailController.text = user!.email;
                        }
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
                              onPressed: handleEmailUpdate,
                            );
                          },
                        );
                      },
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    CardTile(
                      title: "Senha",
                      icon: Icons.key,
                      onTap: () {
                        passwordController.text = "";
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InputDialog(
                              controller: passwordController,
                              title: "Alterar senha",
                              obscureText: true,
                              message: const [
                                TextSpan(
                                  text: "Insira sua nova senha:",
                                  style: TextStyle(color: AppColors.fontBright),
                                ),
                              ],
                              label: "Senha",
                              buttonLabel: "Alterar",
                              onPressed: handlePasswordUpdate,
                            );
                          },
                        );
                      },
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
                    CardTile(
                      title: "Glicemia máxima",
                      icon: Icons.health_and_safety_rounded,
                      iconBackgroundColor: Colors.blue,
                      onTap: () {
                        if (user == null) {
                          return;
                        }

                        maxBloodGlucoseController.text = user!.maxBloodGlucose.toString();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InputDialog(
                              controller: maxBloodGlucoseController,
                              title: "Alterar glicemia máxima",
                              message: const [
                                TextSpan(
                                  text: "Insira sua glicemia máxima:",
                                  style: TextStyle(color: AppColors.fontBright),
                                ),
                              ],
                              label: "Glicemia máxima",
                              buttonLabel: "Alterar",
                              onPressed: handleMaxBloodGlucoseUpdate,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            );
                          },
                        );
                      },
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    CardTile(
                      title: "Glicemia mínima",
                      icon: Icons.health_and_safety_rounded,
                      iconBackgroundColor: Colors.blue,
                      onTap: () {
                        if (user == null) {
                          return;
                        }

                        minBloodGlucoseController.text = user!.minBloodGlucose.toString();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InputDialog(
                              controller: minBloodGlucoseController,
                              title: "Alterar glicemia mínima",
                              message: const [
                                TextSpan(
                                  text: "Insira sua glicemia mínima:",
                                  style: TextStyle(color: AppColors.fontBright),
                                ),
                              ],
                              label: "Glicemia máxima",
                              buttonLabel: "Alterar",
                              onPressed: handleMinBloodGlucoseUpdate,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            );
                          },
                        );
                      },
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    CardTile(
                      title: "Constante insulínica",
                      icon: Icons.calendar_month_rounded,
                      iconBackgroundColor: Colors.blue,
                      onTap: () {
                        if (user != null) {
                          insulinController.text = user!.constanteInsulinica.toStringAsFixed(0);
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return InputDialog(
                              controller: insulinController,
                              title: "Alterar constante insulínica",
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              message: const [
                                TextSpan(
                                  text: "Insira sua constante insulínica:",
                                  style: TextStyle(color: AppColors.fontBright),
                                ),
                              ],
                              label: "Constante insulínica",
                              buttonLabel: "Alterar",
                              onPressed: handleInsulinUpdate,
                            );
                          },
                        );
                      },
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
                      Text(
                        "Sair",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
