import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Меню настроек'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Настройка 1'),
            onTap: () {
              // Действия при нажатии на настройку 1
              Navigator.pop(context); // Закрываем всплывающее окно после нажатия
            },
          ),
          ListTile(
            title: Text('Настройка 2'),
            onTap: () {
              // Действия при нажатии на настройку 2
              Navigator.pop(context); // Закрываем всплывающее окно после нажатия
            },
          ),
          // Добавьте любые другие настройки, которые вам нужны
        ],
      ),
    );
  }
}