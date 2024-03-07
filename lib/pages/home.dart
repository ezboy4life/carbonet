import 'package:flutter/material.dart';
import 'package:carbonet/widgets/card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.cards,
  });

  final List<CardButton> cards;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: cards.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) => cards[index],
      ),
    );
  }
}
