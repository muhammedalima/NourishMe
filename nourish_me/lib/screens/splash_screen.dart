import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/screens/loginsignup/wrapper.dart';
import 'package:nourish_me/theme_library/theme_library.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Wrapper()));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Image.asset(
              "assets/images/NourishNavyNobgeyeblink.png",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'NorishMe',
            style: TextStyle(
              color: Primary_green,
              fontSize: 32,
            ),
          )
        ],
      ),
    ));
  }
}
