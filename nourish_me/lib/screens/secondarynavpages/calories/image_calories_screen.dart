import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nourish_me/screens/secondarynavpages/calories/calories_screen.dart';
import 'package:nourish_me/theme%20library/theme_library.dart';

class ImageCaloriesPage extends StatefulWidget {
  final File imagefile;

  ImageCaloriesPage({
    super.key,
    required this.imagefile,
  });

  @override
  State<ImageCaloriesPage> createState() => _ImageCaloriesPageState();
}

class _ImageCaloriesPageState extends State<ImageCaloriesPage> {
  int Amount = 1;
  String FoodName = 'Iddle';
  int Calories = 200;
  int FinalCalories = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FinalCalories = Calories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        backgroundColor: Primary_green,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(37),
          child: Column(
            children: [
              Container(
                height: 180,
                color: Primary_green,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(widget.imagefile),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        color: Primary_green,
                        child: Text(
                          FoodName,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
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
                      Text(
                        'Amount : ${Amount.toString()}',
                        style: TextStyle(
                          color: Colors.white,
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
                                return;
                              } else {
                                Amount = Amount - 1;
                                FinalCalories = Calories * Amount;
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
                              FinalCalories = Calories * Amount;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 350,
                child: SingleChildScrollView(
                  child: Text(
                    'You Have Eaten ${Amount.toString()} ${FoodName} Which Contain ${FinalCalories.toString()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
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
                        (context),
                        MaterialPageRoute(builder: (context) => CaloriesPage()),
                        (Route<dynamic> route) => true,
                      );
                      print(
                        'Added',
                      );
                    },
                    child: const Text(
                      'Add',
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
    );
  }
}
