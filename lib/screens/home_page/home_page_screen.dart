import 'package:flutter/material.dart';
import 'package:nourish_me/database/databasecalories.dart';
import 'package:nourish_me/database/databaseuser.dart';
import 'package:nourish_me/functions/repeatfunction.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';
import 'package:nourish_me/screens/other_trackers/Diet_plan/Diet_planer.dart';
import 'package:nourish_me/screens/other_trackers/water_tracker/water_tracker.dart';
import 'package:nourish_me/screens/secondarynavpages/Weight_Page/weight_page.dart';
import 'package:nourish_me/screens/secondarynavpages/calories/calories_screen.dart';

class homeScreenPage extends StatefulWidget {
  const homeScreenPage({super.key});

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<homeScreenPage> {
  late String value;
  bool isloading = true;
  String targetCalorie = "0";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isloading = true;
    });

    try {
      await UserDB().RefreshData();
      String target =
          await CaloriesDB().getTargetCalorie(ParsedateDB(DateTime.now()));
      setState(() {
        value = ((int.parse(getTotalCalorie()) / 1000).round()).toString();
        targetCalorie = target;
        isloading = false;
      });
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          
            child: Column(
              
              children: [
                AddCard(
                  progressindex: targetCalorie != "0"
                      ? (int.parse(getTotalCalorie()) /
                              int.parse(targetCalorie))
                          .clamp(0.0, 1.0)
                      : 0.0,
                  screens: CaloriesPage(),
                  headingTitle: 'Goal',
                  headingInsideCard: targetCalorie != "0"
                      ? '${value}/${(int.parse(targetCalorie) / 1000).round()}Kcal'
                      : '${value}/Kcal',
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(37.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
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
                              boxcolor: const Color(0xFFC0DB3F),
                            ),
                          ),
                          Expanded(
                            child: SquareBox(
                              screens: DietPlaner(),
                              heading: 'Diet Plan \n For The Day',
                              boxcolor: const Color(0xFF5E3FDB),
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
