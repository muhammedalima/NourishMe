// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';
import 'package:nourish_me/screens/secondarynavpages/widgets/secondarypagewidgets.dart';
import 'package:nourish_me/theme_library/theme_library.dart';
import 'package:intl/intl.dart';
import 'package:nourish_me/database/databasecalories.dart';

class CaloriesPage extends StatefulWidget {
  const CaloriesPage({super.key});

  @override
  State<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  final NameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String PrintedDate = 'Today';

  String Parsedate(DateTime date) {
    return '${DateFormat.d().format(date)} ${DateFormat.MMM().format(date)}';
  }

  String ParsedateDB(DateTime date) {
    return '${DateFormat.yMMMd().format(date)}';
  }

  late List<CaloriesListItem> CalorieListed;
  bool isLoading = true;
  @override
  void initState() {
    isLoading = true;
    CaloriesDB().getList(ParsedateDB(_selectedDate)).then((value) {
      setState(() {
        CalorieListed = value;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calories'),
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
                                firstDate: DateTime.now()
                                    .subtract(Duration(days: 365)),
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
                                    CaloriesDB()
                                        .getList(ParsedateDB(_selectedDate))
                                        .then((value) {
                                      setState(() {
                                        CalorieListed = value;
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
                    'Update Calories of ${PrintedDate}',
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
                              controller: NameController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Food You Ate',
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
                              icon: const Icon(Icons.photo_camera),
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CameraAccessWidget(),
                                    ));
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
                                  if (NameController.text.isEmpty) {
                                    Get.snackbar(
                                        "Error", "Please fill in all fields.",
                                        colorText: Colors.black);
                                    return;
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await CaloriesDB()
                                        .addCalories(
                                            NameController.text,
                                            ParsedateDB(_selectedDate),
                                            CalorieListed)
                                        .then((value) {
                                      CaloriesDB()
                                          .getList(ParsedateDB(_selectedDate))
                                          .then((value) {
                                        setState(() {
                                          NameController.clear();

                                          isLoading = false;

                                          WidgetsBinding.instance.focusManager
                                              .primaryFocus
                                              ?.unfocus();
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
                                final _Calories = CalorieListed[index];
                                return Slidable(
                                  key: Key(_Calories.id!),
                                  startActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (ctx) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          print(_Calories.id);
                                          CaloriesDB()
                                              .deleteCalories(_Calories.id!,
                                                  ParsedateDB(_selectedDate))
                                              .then((value) {
                                            CaloriesDB()
                                                .getList(
                                                    ParsedateDB(_selectedDate))
                                                .then((value) {
                                              setState(() {
                                                CalorieListed = value;
                                                isLoading = false;
                                              });
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
                                        _Calories.name!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Text(
                                        _Calories.calorie!,
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
                              itemCount: CalorieListed.length)),
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
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
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
      ),
    );
  }
}
