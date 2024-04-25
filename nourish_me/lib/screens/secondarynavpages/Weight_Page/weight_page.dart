import 'package:flutter/material.dart';
import 'package:nourish_me/screens/home/home_screen.dart';
import 'package:nourish_me/theme_library/theme_library.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  bool edit = false;
  int currentweight = 48;
  int targetweight = 70;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weight'),
        backgroundColor: Primary_green,
      ),
      body: SafeArea(
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
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '${currentweight.toString()}kg',
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
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '${targetweight.toString()}kg',
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
                      //Ink(
                      //width: 40,
                      //decoration: const ShapeDecoration(
                      //color: Color(0xFFC0DB3F),
                      //shape: CircleBorder(),
                      //),
                      //child: IconButton(
                      //icon: const Icon(Icons.check),
                      //color: Colors.white,
                      //onPressed: () {},
                      //),
                      //),
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
                    onPressed: () {
                      setState(() {
                        edit
                            ? edit = false
                            : Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (Route<dynamic> route) => false,
                              );
                        print(
                          'Done',
                        );
                      });
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
