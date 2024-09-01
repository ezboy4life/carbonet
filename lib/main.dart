// Padrões do Flutter
// import 'package:carbonet/pages/register.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Widgets
import 'package:carbonet/widgets/card.dart';
import 'package:carbonet/widgets/bottom_icon.dart';
// Páginas
import 'package:carbonet/pages/home.dart';
import 'package:carbonet/pages/settings.dart';
import 'package:carbonet/pages/login.dart';
// Etc
import "package:carbonet/utils/app_colors.dart";
import 'package:carbonet/utils/logger.dart';

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
    return MaterialApp(
      title: 'CarboNet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.defaultAppColor),
        useMaterial3: true,
        splashFactory: NoSplash.splashFactory,
      ),
      home: const LoginPage(),
    );
  }
}
