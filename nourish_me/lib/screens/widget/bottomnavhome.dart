import 'package:flutter/material.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/theme%20library/theme_library.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedIndexNotifier,
      builder: (BuildContext ctx, int updateIndex, Widget? _) {
        return BottomNavigationBar(
          currentIndex: updateIndex,
          selectedItemColor: Colors.white,
          backgroundColor: Primary_green,
          onTap: (newIndex) {
            HomeScreen.selectedIndexNotifier.value = newIndex;
            return;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            )
          ],
        );
      },
    );
  }
}
