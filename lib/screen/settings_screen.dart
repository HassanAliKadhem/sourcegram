import 'package:flutter/material.dart';

import '../model/data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void changeThemeMode(ThemeMode newMode) {
    config.themeMode = newMode;
  }

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
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListenableBuilder(
              listenable: config,
              child: const ListTile(
                title: Text("Theme Mode"),
                leading: Icon(Icons.design_services),
              ),
              builder: (context, child) {
                return Column(
                  children: [
                    child!,
                    RadioListTile<ThemeMode>(
                      title: const Text("🅰️ System"),
                      value: ThemeMode.system,
                      groupValue: config.themeMode,
                      onChanged: (value) => changeThemeMode(value!),
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text("🌑 Dark"),
                      value: ThemeMode.dark,
                      groupValue: config.themeMode,
                      onChanged: (value) => changeThemeMode(value!),
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text("☀️ Light"),
                      value: ThemeMode.light,
                      groupValue: config.themeMode,
                      onChanged: (value) => changeThemeMode(value!),
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
        const AboutListTile(
          icon: Icon(Icons.info),
          applicationVersion: "1.0.0",
        ),
      ],
    );
  }
}
