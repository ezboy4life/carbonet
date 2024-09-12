import 'package:carbonet/pages/add_refeicao.dart';
import 'package:carbonet/pages/home.dart';
import 'package:carbonet/pages/listar_refeicoes.dart';
import 'package:carbonet/utils/app_colors.dart';
// import 'package:carbonet/utils/logger.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier<int>(0);

  final List<Widget> _pages = [
    const HomePage(),
    const Placeholder(),
    const AdicionarRefeicao(),
    ListarRefeicoes(),
    const Placeholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      // Página de adc alimentos é uma exceção e vai ser um modal
      if (index == 2) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: const AdicionarRefeicao(),
            );
          },
        );
        return;
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
            Icon(
              Icons.disabled_by_default_outlined,
              color: Colors.white,
            ),
            Text(
              "CarboNet",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndexNotifier.value,
        children: _pages,
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
