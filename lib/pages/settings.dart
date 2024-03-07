import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.onTap,
  });

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
      itemBuilder: (context, index) => const ListTile(
        leading: FlutterLogo(),
        title: Text("Notificações"),
      ),
    );
  }
}
