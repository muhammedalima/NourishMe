import 'package:flutter/material.dart';
import 'package:nourish_me/database/databaseuser.dart';
import 'package:nourish_me/screens/other_trackers/Diet_plan/Diet_planer.dart';
import 'package:nourish_me/screens/other_trackers/water_tracker/water_tracker.dart';
import 'package:nourish_me/screens/secondarynavpages/Weight_Page/weight_page.dart';
import 'package:nourish_me/screens/secondarynavpages/calories/calories_screen.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';
import 'package:nourish_me/screens/secondarynavpages/exercise_page/exercisepage.dart';

class homeScreenPage extends StatefulWidget {
  const homeScreenPage({super.key});

  @override
  State<homeScreenPage> createState() => _homeScreenPageState();
}

class _homeScreenPageState extends State<homeScreenPage> {
  @override
  late String value;
  bool isloading = true;
  void initState() {
    isloading = true;
    UserDB().RefreshData().then((v) {
      value = ((int.parse(getTotalCalorie()) / 1000).round()).toString();
      isloading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? LoadingScreen()
        : SingleChildScrollView(
            child: Column(
              children: [
                AddCard(
                  progressindex: 0.1,
                  screens: CaloriesPage(),
                  headingTitle: 'Goal',
                  headingInsideCard: '${value}/Kcal',
                  subHeadingCard: 'Eat Upto Today',
                ),
                AddCard(
                  progressindex:
                      (int.parse(getTWeight()) / int.parse(getWeight())) / 10,
                  screens: WeightPage(),
                  headingTitle: 'Weight',
                  headingInsideCard: '${getWeight()}kg',
                  subHeadingCard:
                      'Gain ${(int.parse(getTWeight()) - int.parse(getWeight()))}kg',
                ),
                /*
                AddCard(
                  progressindex: 0.2,
                  screens: ExercisePage(),
                  headingTitle: 'Exercise',
                  headingInsideCard: 'Hard',
                  subHeadingCard: 'Exercise Type',
                ),*/
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
                      //Row(
                      //children: [
                      //Expanded(
                      //child: SquareBox(
                      //screens: CaloriesPage(),
                      //heading: 'Check Your\nCalorie',
// boxcolor: Color(0xFF5E3FDB),
//                      ),
//                    ),
                      //                   Expanded(
                      //                    child: SquareBox(
                      //                     screens: CaloriesPage(),
                      //                    heading: 'Educational\nResources',
                      //                   boxcolor: Color(0xFFC0DB3F),
                      //               ),
                      //           ),
                      //       ],
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
