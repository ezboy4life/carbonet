import 'package:flutter/material.dart';
import 'package:carbonet/widgets/card.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
    required this.cards,
  });

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

  final List<CardButton> cards;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: cards.length,
        // itemBuilder: (context, index) => CardButton(
        //   icon: Icon(
        //     icons[index],
        //     size: 44,
        //     color: Colors.white,
        //   ),
        //   title: titles[index],
        //   subtitle: subtitles[index],
        //   onTap: () => {
        //     infoLog('Page: $index'),
        //   },
        // ),
        itemBuilder: (context, index) => cards[index]
      ),
    );
  }
}
