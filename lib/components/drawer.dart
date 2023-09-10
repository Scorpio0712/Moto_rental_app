import 'package:carrental_app/components/my_list_tile.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onSignOut;
  const MyDrawer({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2D3250),
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          MyListTile(
            icon: Icons.home,
            text: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          MyListTile(
            icon: Icons.settings,
            text: 'Setting',
            onTap: () => Navigator,
          ),
          MyListTile(
            icon: Icons.logout,
            text: 'Log out',
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
