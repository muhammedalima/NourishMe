import 'package:flutter/material.dart';
import 'package:nourish_me/screens/other_trackers/Diet_plan/NourishNavi.dart';
import 'package:nourish_me/theme_library/theme_library.dart';

class DietPlaner extends StatelessWidget {
  const DietPlaner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NourishNavy',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Primary_voilet,
                ),
              ),
              Image.asset(
                "assets/images/NourishNavyNobg.png",
                height: 250,
              ),
              Text(
                'Hello! Let’s Look\nAt Today’s Diet\nPlan for you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF474747),
                  fontSize: 21,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Primary_voilet,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NourishNavi()),
                      );
                    },
                    child: const Text(
                      'Let’s Go',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
