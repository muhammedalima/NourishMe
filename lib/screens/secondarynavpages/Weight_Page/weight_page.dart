import 'package:flutter/material.dart';
import 'package:nourish_me/database/databaseuser.dart';
import 'package:nourish_me/functions/repeatfunction.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';
import 'package:nourish_me/constants/Constants.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  bool edit = false;
  late int currentweight;
  late int targetweight;

  final tweightcontroller = TextEditingController();
  final weightcontroller = TextEditingController();

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    UserDB().RefreshData().whenComplete(
          () => setState(() {
            print(getWeight());
            currentweight = int.parse(getWeight());
            targetweight = int.parse(getTWeight());
            isLoading = false;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight'),
        backgroundColor: Primary_green,
      ),
      body: isLoading
          ? LoadingScreen()
          : SafeArea(
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
                        !edit
                            ? Ink(
                                width: 40,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFC0DB3F),
                                  shape: CircleBorder(),
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    setState(() {
                                      edit = true;
                                    });
                                  },
                                ),
                              )
                            : SizedBox(
                                height: 20,
                              )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      edit ? 'Update Current Weight' : 'Current Weight',
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
                          children: [
                            edit
                                ? Flexible(
                                    child: TextFormField(
                                      controller: weightcontroller,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            '${currentweight.toString()}kg',
                                        hintStyle: TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        currentweight.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'kg',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      edit ? 'Update Target Weight' : 'Target Weight',
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
                          children: [
                            edit
                                ? Flexible(
                                    child: TextFormField(
                                      controller: tweightcontroller,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            '${targetweight.toString()}kg',
                                        hintStyle: TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        targetweight.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        'kg',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
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
                          onPressed: () async {
                            try {
                              if (edit) {
                                setState(() {
                                  isLoading = true;
                                });

                                if (weightcontroller.text.isEmpty) {
                                  weightcontroller.text =
                                      currentweight.toString();
                                }
                                if (tweightcontroller.text.isEmpty) {
                                  tweightcontroller.text =
                                      targetweight.toString();
                                }

                                await UserDB().addCurrentWeight(
                                  weightcontroller.text,
                                );
                                await UserDB().addTargetWeight(
                                  tweightcontroller.text,
                                );
                                await UserDB().RefreshData();

                                setState(() {
                                  currentweight = int.parse(getWeight());
                                  targetweight = int.parse(getTWeight());
                                  edit = false;
                                  isLoading = false;
                                });
                              } else {
                                setState(() {
                                  edit = true;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (Route<dynamic> route) => false,
                                  );
                                });
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(popumsg('Oops', e.toString()));
                            }
                          },
                          child: Text(
                            edit ? 'Add' : 'Done',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
