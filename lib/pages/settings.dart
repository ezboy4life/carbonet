import 'package:carbonet/utils/logger.dart';
import 'package:flutter/material.dart';

class Option {
  final IconData icon;
  final String title;
  final void Function() onTap;

  Option(this.icon, this.title, this.onTap);
}

class SettingsPage extends StatelessWidget {
  SettingsPage({
    super.key,
  });


  final List<Option> optionsList = [
    Option(Icons.abc, "teste", () => infoLog("Opção 01")),
    Option(Icons.access_alarm, "teste2", () => infoLog("Opção 02")),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: optionsList.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
      itemBuilder: (context, index) => ListTile(
        leading: Icon(optionsList[index].icon),
        title: Text(optionsList[index].title),
        onTap: optionsList[index].onTap,
      ),
    );
  }
}
