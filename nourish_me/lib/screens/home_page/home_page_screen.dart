import 'package:flutter/material.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';

class homeScreenPage extends StatelessWidget {
  const homeScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
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
      ],
    );
  }
}
