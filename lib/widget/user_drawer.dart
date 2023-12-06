
import 'package:carrental_app/page/user/my_order_page.dart';
import 'package:carrental_app/widget/user_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  final void Function()? onSignOut;
  const UserDrawer({super.key, required this.onSignOut});

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

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
          UserListTile(
            icon: Icons.home,
            text: 'Home',
            onTap: () => Navigator.pop(context),
          ),
          UserListTile(
            icon: Icons.list,
            text: 'My Order',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyOrderPage(),
              ),
            ),
          ),
          UserListTile(
            icon: Icons.logout,
            text: 'Log out',
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
