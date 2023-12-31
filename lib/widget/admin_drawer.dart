
import 'package:carrental_app/widget/admin_list_tile.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  final void Function()? onSignOut;
  const AdminDrawer({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xffffb17a),
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          AdminListTile(
            icon: Icons.home,
            text: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          AdminListTile(
            icon: Icons.motorcycle,
            text: 'Stock motorcycle',
            onTap: () =>  Navigator.pushNamed(context, '/stock-motor'),
          ),
          AdminListTile(
            icon: Icons.logout,
            text: 'Log out',
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
