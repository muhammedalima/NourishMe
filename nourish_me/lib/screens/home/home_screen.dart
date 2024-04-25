import 'package:flutter/material.dart';
import 'package:nourish_me/screens/home_page/home_page_screen.dart';
import 'package:nourish_me/screens/profile/profile_screen.dart';
import 'package:nourish_me/screens/widget/bottomnavhome.dart';
import 'package:nourish_me/theme_library/theme_library.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [
    //totoal number of pages in the list
    homeScreenPage(),
    ProfileScreen(),
  ];

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
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, Widget? _) {
            return _pages[updatedIndex];
          },
        ),
      ),

      bottomNavigationBar: const BottomNav(),
    );
  }
}
