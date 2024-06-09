import 'package:flutter/material.dart';
import 'package:nourish_me/screens/home_page/home_page_screen.dart';
import 'package:nourish_me/screens/profile/profile_screen.dart';
import 'package:nourish_me/screens/widget/bottomnavhome.dart';
import 'package:nourish_me/constants/Constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pages = const [
    //totoal number of pages in the list
    homeScreenPage(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboardOpen = bottomInsets != 0;
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
          valueListenable: HomeScreen.selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, Widget? _) {
            return _pages[updatedIndex];
          },
        ),
      ),

      bottomNavigationBar: isKeyboardOpen ? SizedBox() : BottomNav(),
    );
  }
}
