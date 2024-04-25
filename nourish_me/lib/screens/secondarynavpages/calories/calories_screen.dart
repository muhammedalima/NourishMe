import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/screens/secondarynavpages/widgets/secondarypagewidgets.dart';
import 'package:nourish_me/theme_library/theme_library.dart';
import 'package:intl/intl.dart';

class CaloriesPage extends StatefulWidget {
  const CaloriesPage({super.key});

  @override
  State<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  DateTime _selectedDate = DateTime.now();
  String PrintedDate = 'Today';
  String Parsedate(DateTime date) {
    return '${DateFormat.d().format(date)} ${DateFormat.MMM().format(date)}';
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
                              final _selectedDatetemp = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate:
                                    DateTime.now().subtract(Duration(days: 30)),
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
                                  if (_selectedDatetemp != DateTime.now()) {
                                    _selectedDate = _selectedDatetemp!;

                                    PrintedDate = Parsedate(_selectedDate);
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
                    height: 500,
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
                                title: Text(
                                  'Bread & Omlette',
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
