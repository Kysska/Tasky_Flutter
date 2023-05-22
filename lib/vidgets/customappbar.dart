import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLeadingPressed;
  final VoidCallback onProfileIconPressed;

  const CustomAppBar({
    Key? key,
    required this.onLeadingPressed,
    required this.onProfileIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Image.asset(
              'images/options.png',
              width: 30,
              height: 30,
            ),
            onPressed: onLeadingPressed,
          );
        },
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          onPressed: onProfileIconPressed,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}