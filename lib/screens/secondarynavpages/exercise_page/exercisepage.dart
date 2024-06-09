import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/constants/Constants.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  Duration time = Duration(hours: 1, minutes: 23);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
        backgroundColor: Primary_green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 37.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Exercise Type',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(
                    6,
                  ),
                  height: 60,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Hard',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Exercises Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(
                    6,
                  ),
                  height: 60,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter the exercise name',
                              hintStyle: TextStyle(color: Colors.white30),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Ink(
                          width: 40,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFC0DB3F),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.timer),
                            color: Colors.white,
                            onPressed: () {
                              _showDialog(context);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Ink(
                          width: 40,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFC0DB3F),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.check),
                            color: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 430,
                  child: ListView.separated(
                      itemBuilder: (BuildContext, int) {
                        return Slidable(
                          key: const Key('1'),
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (ctx) {},
                                icon: Icons.delete,
                                label: 'Delete',
                                backgroundColor: Colors.black,
                              ),
                            ],
                          ),
                          child: Card(
                            color: Primary_green,
                            child: const ListTile(
                              leading: Text(
                                '15:00',
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              title: Text(
                                'Running',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Text(
                                '10kcal',
                                style: TextStyle(
                                  color: Color(0xFF6F6F6F),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, int) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      itemCount: 10),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Primary_green,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                        print(
                          'Completed',
                        );
                      },
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.black,
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
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 216,
          color: Primary_green,
          child: CupertinoTimerPicker(
            backgroundColor: Primary_green,
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: Duration(),
            onTimerDurationChanged: (Duration time) {
              setState(() {});
            },
          ),
        );
      },
    );
  }
}
