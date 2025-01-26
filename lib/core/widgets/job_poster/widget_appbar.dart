import 'package:flutter/material.dart';

class PosterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  const PosterAppBar({
    required this.themeMode,
    required this.toggleTheme,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(
            themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
            color: Colors.black,
          ),
          onPressed: toggleTheme,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
