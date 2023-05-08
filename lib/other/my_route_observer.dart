import 'package:flutter/material.dart';
import 'package:kasir/main.dart';
import 'package:kasir/other/sqflite.dart';

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic> route) async {
    var currentRoute = route.settings.name;

    List<dynamic> token = await tableShow('personal_token');
    if ((currentRoute != '/') && token.isEmpty) {
      navigatorKey.currentState?.pushReplacementNamed('/');
    }

    if (currentRoute == '/' && token.isNotEmpty) {
      navigatorKey.currentState?.pushReplacementNamed('dashboard');
    }

    print('observer');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
