import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourish_me/constants/Constants.dart';
import 'package:nourish_me/database/databaseuser.dart';
import 'package:nourish_me/functions/repeatfunction.dart';
import 'package:nourish_me/screens/home_page/widgets/home_widgets.dart';
import 'package:nourish_me/screens/loginsignup/wrapper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool edit;
  final tweightcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final heightcontroller = TextEditingController();
  final weightcontroller = TextEditingController();
  final gendercontroller = TextEditingController();
  final agecontroller = TextEditingController();
  final List<String> list = <String>['Male', 'Female'];
  final List<String> _image = [
    'UnderWeight',
    'NormalWeight',
    'Obesity',
    'OverWeight',
    'OverWeight',
  ];
  final List<Color> _Clr = [
    Colors.lightBlue,
    Colors.green,
    Colors.yellow,
    Colors.red,
    Colors.pink,
  ];
  late int id;
  late String age;
  late String weight;
  late String height;
  late String bmi;
  late String gender;
  late String tweight;
  late String noofday;

  getData() {
    name = getName();
    height = getHeight();
    gender = getGender();
    bmi = getbmi();
    weight = getWeight();
    tweight = getTWeight();
    age = getAge();
    if (int.parse(bmi) < 18.5) {
      id = 0;
    } else if (int.parse(bmi) < 25) {
      id = 1;
    } else if (int.parse(bmi) < 30) {
      id = 2;
    } else if (int.parse(bmi) < 40) {
      id = 3;
    } else {
      id = 4;
    }
    noofday = getnoofday();
  }

  SignOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => Wrapper());
  }

  bool isLoading = false;
  late String name;
  @override
  void initState() {
    edit = false;
    super.initState();
    isLoading = true;
    UserDB().RefreshData().whenComplete(() {
      getData();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? LoadingScreen()
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 37.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      edit
                          ? SizedBox(
                              height: 20,
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: ShapeDecoration(
                                    color: _Clr[id],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                  height: 150,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        "assets/images/${gender == 'Male' ? 'Man' : 'Women'}${_image[id]}.png",
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'BMI is ',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              '${bmi}',
                                              style: TextStyle(
                                                color: Primary_voilet,
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                'You Are\n ${_image[id]}',
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                      edit
                          ? SizedBox()
                          : (noofday != '0')
                              ? Text(
                                  'it take ${noofday}days you to get target weight',
                                  style: TextStyle(color: Colors.yellow[200]),
                                )
                              : SizedBox(),
                      Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(
                          6,
                        ),
                        width: double.infinity,
                        height: 50,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: edit
                              ? TextFormField(
                                  controller: namecontroller,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: name,
                                    hintStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Mail',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(
                          6,
                        ),
                        width: double.infinity,
                        height: 50,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 1, color: Colors.white),
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${user!.email}',
                            style: TextStyle(
                              color: edit ? Colors.white70 : Colors.white,
                              fontSize: edit ? 15 : 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Height',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(
                                    6,
                                  ),
                                  height: 50,
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: edit
                                        ? TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: heightcontroller,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: height,
                                              hintStyle: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            height,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weight',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(
                                    6,
                                  ),
                                  height: 50,
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: edit
                                        ? TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: weightcontroller,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: weight,
                                              hintStyle: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            weight,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      edit
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Target Weight',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(
                                    6,
                                  ),
                                  height: 50,
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: tweightcontroller,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: tweight,
                                          hintStyle: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      )),
                                ),
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Age',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(
                                    6,
                                  ),
                                  height: 50,
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: edit
                                        ? TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: agecontroller,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: age,
                                              hintStyle: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            age,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(6),
                                  height: 50,
                                  width: double.infinity,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Colors.white),
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                  child: edit
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: DropdownMenu(
                                            expandedInsets: EdgeInsets.zero,
                                            controller: gendercontroller,
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                            ),
                                            hintText: gender,
                                            inputDecorationTheme:
                                                InputDecorationTheme(
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            dropdownMenuEntries: list
                                                .map<DropdownMenuEntry<String>>(
                                                    (String value) {
                                              return DropdownMenuEntry<String>(
                                                  value: value, label: value);
                                            }).toList(),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            gender,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Primary_green),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    try {
                                      if (edit) {
                                        if (namecontroller.text.isEmpty ||
                                            weightcontroller.text.isEmpty ||
                                            heightcontroller.text.isEmpty ||
                                            agecontroller.text.isEmpty ||
                                            gendercontroller.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(popumsg(
                                                  'Oops', 'Enter the details'));
                                          return;
                                        } else {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          await UserDB()
                                              .addUserDetail(
                                                  namecontroller.text,
                                                  weightcontroller.text,
                                                  tweightcontroller.text,
                                                  heightcontroller.text,
                                                  agecontroller.text,
                                                  gendercontroller.text)
                                              .whenComplete(() {
                                            setState(() {
                                              getData();
                                              edit = false;
                                              isLoading = false;
                                            });
                                          });
                                        }
                                      } else
                                        setState(() {
                                          edit = true;
                                        });
                                    } catch (e) {
                                      throw e;
                                    }
                                  },
                                  child: Text(
                                    edit ? 'Done' : 'Edit',
                                    style: TextStyle(
                                      color: Primary_green,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Primary_green,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    edit
                                        ? setState(() {
                                            edit = false;
                                            isLoading = false;
                                          })
                                        : SignOut();
                                  },
                                  child: Text(
                                    edit ? 'Cancel' : 'Log Out',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      edit
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Note : This app restrict the intake addition food upto 500Kcal visit  https://news.sanfordhealth.org/healthy-living/weight-gain-performance/',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
