import 'package:flutter/material.dart';
import 'package:nourish_me/screens/widget/bottomnavhome.dart';
import 'package:nourish_me/theme%20library/theme_library.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar
      appBar: AppBar(
        backgroundColor: Primary_green,
        title: const Text(
          'NourishMe',
          style: TextStyle(color: Colors.white),
        ),
      ),

      //body
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(color: Primary_green),
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
