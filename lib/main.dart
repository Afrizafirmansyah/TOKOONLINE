import 'package:dahar/screens/checkout.dart';
import 'package:flutter/material.dart';
import 'package:dahar/screens/home.dart';
import 'package:dahar/screens/item_detail.dart';
import 'package:dahar/screens/order_history.dart';
import 'package:dahar/screens/detail_toko.dart';
import 'package:dahar/screens/menu_toko.dart';
import 'package:dahar/screens/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dahar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/register',
      routes: {
        '/home': (context) => const Home(),
        '/item_detail': (context) => const ItemDetail(),
        '/order_history': (context) => const OrderHistory(),
        '/detail_toko': (context) => const DetailToko(),
        '/menu_toko': (context) => const MenuToko(),
        '/register': (context) => const register(),
        '/checkout': (context) => const checkout(),
      },
    );
  }
}
