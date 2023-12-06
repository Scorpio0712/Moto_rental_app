import 'package:carrental_app/auth/auth_check.dart';
import 'package:carrental_app/auth/main_check.dart';
import 'package:carrental_app/page/admin/add_motor_page.dart';
import 'package:carrental_app/page/admin/admin_home_page.dart';

import 'package:carrental_app/page/admin/stock_motor_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const AuthPage(),
      );
    case AdminHomePage.routeName:
      return MaterialPageRoute(
        builder: (_) => const AdminHomePage(),
      );
    case StockMotorPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const StockMotorPage(),
      );
    case AddMotorPage.routeName:
      return MaterialPageRoute(
        builder: (_) => const AddMotorPage(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => const MainPage(),
      );
  }
}
