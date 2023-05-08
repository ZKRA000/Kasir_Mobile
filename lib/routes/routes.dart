import 'package:flutter/material.dart';
import 'package:kasir/pages/dashboard.dart';
import 'package:kasir/pages/item_form.dart';
import 'package:kasir/pages/item.dart';
import 'package:kasir/pages/login.dart';
import 'package:kasir/pages/nota.dart';
import 'package:kasir/pages/penjualan.dart';
import 'package:kasir/pages/report.dart';
import 'package:kasir/pages/role.dart';
import 'package:kasir/pages/user.dart';
import 'package:kasir/pages/user_form.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const Login(),
  'dashboard': (context) => const Dashboard(),
  'item': (context) => const ItemPage(),
  'item-form': (context) => const ItemFormPage(),
  'nota': (context) => const NotaPage(),
  'penjualan': (context) => const PenjualanPage(),
  'report': (context) => const ReportPage(),
  'role': (context) => const RolePage(),
  'user': (context) => const UserPage(),
  'user-form': (context) => const UserFormPage(),
};
