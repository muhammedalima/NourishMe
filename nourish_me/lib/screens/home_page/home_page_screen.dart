import 'package:flutter/material.dart';
import 'package:nourish_me/screens/other_trackers/Diet_plan/Diet_planer.dart';
import 'package:nourish_me/screens/other_trackers/water_tracker/water_tracker.dart';
import 'package:nourish_me/screens/secondarynavpages/Weight_Page/weight_page.dart';
import 'package:nourish_me/screens/secondarynavpages/calories/calories_screen.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';
import 'package:nourish_me/screens/secondarynavpages/exercise_page/exercisepage.dart';

class homeScreenPage extends StatelessWidget {
  const homeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AddCard(
            screens: CaloriesPage(),
            headingTitle: 'Goal',
            headingInsideCard: '53/Kcal',
            subHeadingCard: 'Eat Upto',
          ),
          AddCard(
            screens: WeightPage(),
            headingTitle: 'Weight',
            headingInsideCard: '48.5kg',
            subHeadingCard: 'Gain 3kg',
          ),
          AddCard(
            screens: ExercisePage(),
            headingTitle: 'Exercise',
            headingInsideCard: 'Hard',
            subHeadingCard: 'Exercise Type',
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(37.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Other Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SquareBox(
                        screens: WaterTracker(),
                        heading: 'Daily Water \n Tracker',
                        boxcolor: Color(0xFFC0DB3F),
                      ),
                    ),
                    Expanded(
                      child: SquareBox(
                        screens: DietPlaner(),
                        heading: 'Diet Plan \n For The Day',
                        boxcolor: Color(0xFF5E3FDB),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: SquareBox(
                        screens: CaloriesPage(),
                        heading: 'Check Your\nCalorie',
                        boxcolor: Color(0xFF5E3FDB),
                      ),
                    ),
                    Expanded(
                      child: SquareBox(
                        screens: CaloriesPage(),
                        heading: 'Educational\nResources',
                        boxcolor: Color(0xFFC0DB3F),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
