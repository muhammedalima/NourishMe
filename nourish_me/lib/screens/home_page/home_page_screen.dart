import 'package:flutter/material.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';
import 'package:nourish_me/theme%20library/theme_library.dart';

class homeScreenPage extends StatelessWidget {
  const homeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          AddCard(
            headingTitle: 'Goal',
            headingInsideCard: '53/Kcal',
            subHeadingCard: 'Eat Upto',
          ),
          AddCard(
            headingTitle: 'Weight',
            headingInsideCard: '48.5kg',
            subHeadingCard: 'Gain 3kg',
          ),
          AddCard(
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
                    SquareBox(
                      heading: 'Daily Water \n Tracker',
                      boxcolor: Color(0xFFC0DB3F),
                    ),
                    SquareBox(
                      heading: 'Diet Plan \n For The Day',
                      boxcolor: Color(0xFF5E3FDB),
                    )
                  ],
                ),
                Row(
                  children: [
                    SquareBox(
                      heading: 'Daily Water \n Tracker',
                      boxcolor: Color(0xFFC0DB3F),
                    ),
                    SquareBox(
                      heading: 'Diet Plan \n For The Day',
                      boxcolor: Color(0xFF5E3FDB),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
