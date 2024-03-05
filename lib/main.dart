import 'package:carbonet/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:carbonet/widgets/card.dart';
import 'package:carbonet/widgets/bottom_icon.dart';
import 'package:carbonet/pages/home.dart';
import 'package:carbonet/assets/app_colors.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.defaultBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPage = 0;

  // final Color defaultBlue = const Color(0xFF0B6FF4);

  @override
  Widget build(BuildContext context) {
    Widget page = const Placeholder();
    infoLog(selectedPage.toString());
    switch (selectedPage) {
      case 0:
        page = HomePage(
          cards: [
            CardButton(
              icon: const Icon(Icons.dining, size: 44, color: Colors.white),
              title: 'title',
              subtitle: 'subtitle',
              onTap: () => {
                setState(() => selectedPage = 2),
              },
            ),
          ],
        );
        break;
      case 1:
        page = const Placeholder();
        break;
      case 2:
        page = const Placeholder();
        break;
      default:
        page = const Placeholder();
        errorLog("No widget for $selectedPage");
    }

    // Esse método é re-executado toda vez que a função setState é chamada.
    return Scaffold(
      extendBody: true,
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppColors.defaultBlue,
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
      body: page,
      bottomNavigationBar: BottomAppBar(
        color: AppColors.defaultBlue,
        child: Row(
          children: [
            BottomIconButton(
              icon: Icons.home_outlined,
              onTap: () => setState(
                () {
                  selectedPage = 0;
                },
              ),
            ),
            BottomIconButton(
              icon: Icons.add_box_outlined,
              onTap: () => setState(
                () {
                  selectedPage = 1;
                },
              ),
            ),
            BottomIconButton(
              icon: Icons.settings_outlined,
              onTap: () => setState(
                () {
                  selectedPage = 2;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
