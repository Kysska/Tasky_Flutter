import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsMenu extends StatefulWidget {
  @override
  _SettingsMenuState createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 80),
              children: [
                SwitchListTile(
                  title: Text('Сменить тему'),
                  value: isDarkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      isDarkModeEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Выход'),
            onTap: () {
              Navigator.pop(context);
              //aaaaaaaa
            },
          ),
        ],
      ),
    );
  }
}