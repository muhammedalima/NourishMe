import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nourish_me/functions/repeatfunction.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';
import 'package:nourish_me/screens/secondarynavpages/widgets/secondarypagewidgets.dart';
import 'package:nourish_me/constants/Constants.dart';
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

  String todaycalorie = '';
  String targetcalorie = '';
  int Amount = 1;
  bool numbervisble = false;
  late List<CaloriesListItem> CalorieListed;
  getvalues() async {
    CalorieListed = await CaloriesDB().getList(ParsedateDB(_selectedDate));
    todaycalorie =
        await CaloriesDB().getTodayCalorie(ParsedateDB(_selectedDate));
    targetcalorie =
        await CaloriesDB().getTargetCalorie(ParsedateDB(_selectedDate));
  }

  bool isLoading = true;
  @override
  void initState() {
    isLoading = true;
    getvalues().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Calories You Intaken',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          isLoading
                              ? LineLoading(length: 160, height: 60)
                              : Text(
                                  '${todaycalorie}/${targetcalorie}',
                                  style: TextStyle(
                                    color: Primary_voilet,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 40,
                                  ),
                                ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                                textTheme:
                                                    ButtonTextTheme.primary),
                                          ),
                                          child: Widget!,
                                        );
                                      },
                                    );

                                    setState(
                                      () {
                                        if (selectedDatetemp !=
                                            DateTime.now()) {
                                          _selectedDate = selectedDatetemp!;
                                          PrintedDate =
                                              Parsedate(_selectedDate);
                                          isLoading = true;
                                          getvalues().then((value) {
                                            setState(() {
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
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
                              onTap: () => setState(() {
                                numbervisble = true;
                              }),
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
                                      builder: (context) => CameraAccessWidget(
                                        selectedDate: _selectedDate,
                                      ),
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        popumsg(
                                            'Oops!', 'Enter the Food name'));
                                    return;
                                  } else {
                                    setState(() {
                                      numbervisble = false;
                                      isLoading = true;
                                      WidgetsBinding
                                          .instance.focusManager.primaryFocus
                                          ?.unfocus();
                                    });
                                    CaloriesDB()
                                        .checkcalories(NameController.text)
                                        .then((value) {
                                      CaloriesDB()
                                          .addCalories(
                                              NameController.text,
                                              ParsedateDB(_selectedDate),
                                              (Amount * value).toString())
                                          .then((value) {
                                        getvalues().then((value) {
                                          setState(() {
                                            Amount = 1;
                                            NameController.clear();
                                            isLoading = false;
                                          });
                                        });
                                      });
                                    });
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      popumsg('Oops', e.toString()));
                                }
                                ;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  numbervisble
                      ? Container(
                          margin: const EdgeInsets.all(
                            6,
                          ),
                          height: 60,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Amount : ${Amount.toString()}',
                                  style: TextStyle(
                                    color: custom_grey,
                                  ),
                                ),
                                Flexible(
                                    child: SizedBox(
                                  width: double.maxFinite,
                                )),
                                Ink(
                                  width: 40,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xFFC0DB3F),
                                    shape: CircleBorder(),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.remove),
                                    color: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        if (Amount == 1) {
                                          Amount = 1;
                                        } else {
                                          Amount = Amount - 1;
                                        }
                                      });
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
                                    onPressed: () {
                                      setState(() {
                                        Amount = Amount + 1;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? LoadingScreen()
                      : Container(
                          height: 450,
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
                                            getvalues().then((value) {
                                              setState(() {
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
