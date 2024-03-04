import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carbonet/widgets/card.dart';
import 'package:carbonet/widgets/bottom_icon.dart';
import 'package:carbonet/assets/app_colors.dart';

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
  final List<String> titles = <String>['Refeição', 'Favoritos', 'Relatórios'];
  final List<String> subtitles = <String>[
    'Cadastrar refeição',
    'Alimentos favoritos',
    'Histórico de refeições'
  ];
  final List<IconData> icons = <IconData>[
    Icons.dining_rounded,
    Icons.favorite,
    Icons.history_rounded
  ];

  // final Color defaultBlue = const Color(0xFF0B6FF4);

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => print("hey"),
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: ListView.separated(
          padding: const EdgeInsets.all(10.0),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) => CardButton(
            icon: Icon(
              icons[index],
              size: 44,
              color: Colors.white,
            ),
            title: titles[index],
            subtitle: subtitles[index],
          ),
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: AppColors.defaultBlue,
        child: Row(
          children: [
            BottomIconButton(icon: Icons.home_outlined),
            BottomIconButton(icon: Icons.add_box_outlined),
            BottomIconButton(icon: Icons.settings_outlined),
          ],
        ),
      ),
    );
  }
}
