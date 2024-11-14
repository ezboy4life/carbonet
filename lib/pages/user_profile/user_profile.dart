import 'package:carbonet/data/models/user.dart';
import 'package:carbonet/utils/logged_user_access.dart';
import 'package:carbonet/widgets/buttons/card.dart';
import 'package:carbonet/widgets/buttons/card_tile.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  final User? user = LoggedUserAccess().user;

  UserProfile({
    super.key,
  });

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
                    const CardTile(
                      title: "Data de nascimento",
                      icon: Icons.calendar_month_rounded,
                    ),
                    Divider(thickness: .5, color: Colors.grey[700], indent: 65),
                    const CardTile(
                      title: "Email",
                      icon: Icons.email,
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
                child: const ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sair", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
