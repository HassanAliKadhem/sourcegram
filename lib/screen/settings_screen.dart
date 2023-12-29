import 'package:flutter/material.dart';

import '../model/data.dart';
import '../util/launch_uri.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          title: Text(
            "Config",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const ListTile(
          title: Text("Theme Mode"),
          leading: Icon(Icons.design_services),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          child: StatefulBuilder(builder: (context, setState) {
            return Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text("🅰️ System"),
                  value: ThemeMode.system,
                  groupValue: Config.of(context).themeMode,
                  onChanged: (value) => Config.of(context).themeMode = value!,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text("🌙 Dark"),
                  value: ThemeMode.dark,
                  groupValue: Config.of(context).themeMode,
                  onChanged: (value) => Config.of(context).themeMode = value!,
                ),
                RadioListTile<ThemeMode>(
                  title: const Text("☀️ Light"),
                  value: ThemeMode.light,
                  groupValue: Config.of(context).themeMode,
                  onChanged: (value) => Config.of(context).themeMode = value!,
                ),
              ],
            );
          }),
        ),
        const ListTile(
          title: Text(
            "About",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const ListTile(
          title: Text("Made by"),
          subtitle: Text("Hasan Kadhem"),
          leading: Icon(Icons.person),
        ),
        const ListTile(
          title: Text("Made using"),
          subtitle: Text("Flutter"),
          leading: FlutterLogo(),
        ),
        ListTile(
          title: const Text("My other apps & games"),
          subtitle: const Text("Open store"),
          leading: const Icon(Icons.launch),
          onTap: () => launchUri(Uri.parse(
              "https://play.google.com/store/apps/developer?id=Hasan+Kadhem+Dev")),
        ),
        const AboutListTile(
          icon: Icon(Icons.info),
          applicationVersion: "1.0.0",
        ),
      ],
    );
  }
}
