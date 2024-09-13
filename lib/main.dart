// Padrões do Flutter
// import 'package:carbonet/pages/register.dart
import 'package:carbonet/pages/home_screen.dart';
import 'package:carbonet/pages/register.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginPage(),
        '/register': (BuildContext context) => const RegisterPage(),
        '/home': (BuildContext context) => const HomeScreen(),
      },
    );
  }
}
