import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nourish_me/functions/repeatfunction.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';
import 'package:nourish_me/screens/other_trackers/water_tracker/databasewater.dart';
import 'package:nourish_me/constants/Constants.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  DateTime _selectedDate = DateTime.now();
  final NumberController = TextEditingController();
  DateTime Timeofwaterdrunk = DateTime.now();
  String PrintedDate = 'Today';
  String Parsedate(DateTime date) {
    return '${DateFormat.d().format(date)} ${DateFormat.MMM().format(date)}';
  }

  String ParseTime(DateTime date) {
    return '${DateFormat.jm().format(date)}';
  }

  late List<WaterListItem> WaterListed;
  bool isLoading = true;
  @override
  void initState() {
    isLoading = true;
    WaterDB().getList(ParsedateDB(_selectedDate)).then((value) {
      setState(() {
        WaterListed = value;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Ink(
                      width: 40,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFC0DB3F),
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                          icon: Icon(Icons.calendar_month),
                          onPressed: () async {
                            DateTime? selectedDatetemp = DateTime.now();
                            selectedDatetemp = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().subtract(Duration(days: 365)),
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor: Primary_green,
                                    colorScheme: ColorScheme.light(
                                        primary: Primary_green),
                                    buttonTheme: ButtonThemeData(
                                        textTheme: ButtonTextTheme.primary),
                                  ),
                                  child: Widget!,
                                );
                              },
                            );

                            setState(
                              () {
                                if (selectedDatetemp != DateTime.now()) {
                                  _selectedDate = selectedDatetemp!;
                                  PrintedDate = Parsedate(_selectedDate);
                                  isLoading = true;
                                  WaterDB()
                                      .getList(ParsedateDB(_selectedDate))
                                      .then((value) {
                                    setState(() {
                                      WaterListed = value;
                                      isLoading = false;
                                    });
                                  });
                                }
                              },
                            );
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Update Calories of ${PrintedDate} ',
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
                            controller: NumberController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Number of Glasses',
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
                            icon: const Icon(Icons.schedule),
                            color: Colors.white,
                            onPressed: () {
                              _showDialog(context);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Ink(
                          width: 40,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFC0DB3F),
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () async {
                              try {
                                if (NumberController.text.isEmpty) {
                                  Get.snackbar(
                                      "Error", "Please fill in all fields.",
                                      colorText: Colors.black);
                                  return;
                                } else {
                                  setState(() {
                                    isLoading = true;
                                    WaterDB().addWater(
                                        ParseTime(Timeofwaterdrunk),
                                        NumberController.text.toString(),
                                        ParsedateDB(_selectedDate));
                                    WidgetsBinding
                                        .instance.focusManager.primaryFocus
                                        ?.unfocus();
                                    WaterDB()
                                        .getList(ParsedateDB(_selectedDate))
                                        .then((value) {
                                      setState(() {
                                        WaterListed = value;
                                        isLoading = false;
                                        NumberController.clear();

                                        isLoading = false;
                                      });
                                    });
                                  });
                                }
                              } catch (e) {
                                Get.snackbar("Error", e.toString(),
                                    colorText: Primary_green);
                              }
                              ;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoading
                    ? LoadingScreen()
                    : Container(
                        height: 500,
                        child: ListView.separated(
                            itemBuilder: (BuildContext, index) {
                              final _Waters = WaterListed[index];
                              return Slidable(
                                key: Key(_Waters.id!),
                                startActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (ctx) {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        WaterDB().deleteWater(_Waters.id!,
                                            ParsedateDB(_selectedDate));
                                        WaterDB()
                                            .getList(ParsedateDB(_selectedDate))
                                            .then((value) {
                                          setState(() {
                                            WaterListed = value;
                                            isLoading = false;
                                          });
                                        });
                                      },
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      backgroundColor: Colors.black,
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: Primary_green,
                                  child: ListTile(
                                    title: Text(
                                      _Waters.wtime!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: Text(
                                      _Waters.Glass!,
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
                            itemCount: WaterListed.length),
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
          child: CupertinoDatePicker(
            backgroundColor: Primary_green,
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime time) {
              setState(() {
                Timeofwaterdrunk = time;
              });
            },
          ),
        );
      },
    );
  }
}
