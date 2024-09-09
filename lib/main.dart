// Padrões do Flutter
// import 'package:carbonet/pages/register.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Widgets
// Páginas
import 'package:carbonet/pages/login.dart';
// Etc
import "package:carbonet/utils/app_colors.dart";

void main() {
  // Trava a orientação do app para sempre ficar na vertical
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const CarboNet());
}

class CarboNet extends StatelessWidget {
  const CarboNet({super.key});

  // Esse widget é a raiz da aplicação.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
