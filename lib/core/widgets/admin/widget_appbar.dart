import 'package:flutter/material.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  const AdminAppBar({
    required this.themeMode,
    required this.toggleTheme,
    Key? key,
  }) : super(key: key);

  @override
 Widget build(BuildContext context) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.black),
    backgroundColor: Colors.transparent,
    elevation: 0, 
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.deepPurple], 
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(
          themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
          color: Colors.black, // Adjust icon color
        ),
        onPressed: toggleTheme,
      ),
    ],
  );
}


  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
