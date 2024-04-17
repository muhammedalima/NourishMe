import 'package:flutter/material.dart';
import 'package:nourish_me/theme%20library/theme_library.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'ProfileScreen',
          style: TextStyle(
            color: Primary_green,
          ),
        ),
      ),
    );
  }
}
