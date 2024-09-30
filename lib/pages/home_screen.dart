import 'package:carbonet/data/models/refeicao.dart';
import 'package:carbonet/pages/add_refeicao.dart';
import 'package:carbonet/pages/camera_functionality.dart';
import 'package:carbonet/pages/home.dart';
import 'package:carbonet/pages/listar_refeicoes.dart';
import 'package:carbonet/pages/registro_favoritos.dart';
import 'package:carbonet/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);
  final List<Refeicao> historicoRefeicoes = [];

  @override
  void initState() {
    super.initState();
  }

  void addMealToHistory(Refeicao refeicao) {
    setState(() {
      historicoRefeicoes.add(refeicao);
    });
  }

  Future<void> showAddMealModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: (MediaQuery.of(context).size.height * 0.9) + 29, // wtf
          child: AdicionarRefeicao(addMealToHistory: addMealToHistory),
        );
      },
    );
    setState(() {});
  }

  Future<void> showEditFavoritesModal() async {
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        barrierColor: Color(Colors.white.value).withOpacity(0.5),
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: RegistroFavoritos(),
          );
        });
  }

  Future<void> showCameraTestModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: Color(Colors.white.value).withOpacity(0.5),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: null,
        );
      }
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        showAddMealModal();
        return;
      } else if (index == 1) {
        showEditFavoritesModal();
        return;
      } else if (index == 4) {
        showCameraTestModal();
      }
      _selectedIndexNotifier.value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/imgs/logo.png"),
              width: 32,
              height: 32,
              fit: BoxFit.fill,
            ),
            SizedBox(width: 16),
            Text(
              "CarboNet",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndexNotifier.value,
        children: [
          const HomePage(),
          const Placeholder(),
          const Placeholder(), // sla :3
          ListarRefeicoes(
            historicoRefeicoes: historicoRefeicoes,
          ),
          const Placeholder(),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _selectedIndexNotifier,
        builder: (context, selectedIndex, child) {
          return Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: _onItemTapped,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_rounded,
                    color: AppColors.fontBright,
                  ),
                  activeIcon: Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search_rounded,
                    color: AppColors.fontBright,
                  ),
                  activeIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: AppColors.fontBright,
                  ),
                  activeIcon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.white,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.history,
                    color: AppColors.fontBright,
                  ),
                  activeIcon: Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_rounded,
                    color: AppColors.fontBright,
                  ),
                  activeIcon: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                  ),
                  label: '',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
