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
      ),
      home: const LoginPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedPage = 0;

  void changePage(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  // Esse método é re-executado toda vez que a função setState é chamada.
  @override
  Widget build(BuildContext context) {
    Widget currentPage;
    switch (selectedPage) {
      case 0:
        currentPage = HomePage(
          // TODO
          // sorry luigi, espero que a mudança maluca que eu fiz (defini os cards dentro da homepage por causa dos contexts) não atrapalhe muito sua visão 😅
          // cards: [
          //   CardButton(
          //     icon: Icons.dining,
          //     title: 'Refeição',
          //     subtitle: 'Cadastrar Refeição',
          //     onTap: () => changePage(1),
          //   ),
          //   CardButton(
          //     icon: Icons.settings,
          //     title: 'Configurações',
          //     subtitle: 'Defina preferências',
          //     onTap: () => changePage(2),
          //   ),
          // ],
        );
        break;
      case 1:
        currentPage = const Placeholder();
        break;
      case 2:
        currentPage = SettingsPage();
        break;
      default:
        currentPage = const Placeholder();
        errorLog("No widget for $selectedPage");
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.defaultAppColor,
        leading: IconButton(
          // icon: Icon(Icons.headphones),
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.network("https://t2.tudocdn.net/125246?w=1920"),
          ),
          onPressed: () => {infoLog("Botão que irá abrir o perfil do usuário")},
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: currentPage,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.defaultAppColor,
        child: Row(
          children: [
            BottomIconButton(
              icon: selectedPage == 0 ? Icons.home_sharp : Icons.home_outlined,
              onTap: () => changePage(0),
            ),
            BottomIconButton(
              icon: Icons.add_box_outlined,
              onTap: () => changePage(1),
            ),
            BottomIconButton(
              icon: Icons.settings_outlined,
              onTap: () => changePage(2),
            ),
          ],
        ),
      ),
    );
  }
}
