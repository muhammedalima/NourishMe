import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourish_me/database/database.dart';
import 'package:nourish_me/theme_library/theme_library.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool edit;
  final namecontroller = TextEditingController();
  final heightcontroller = TextEditingController();
  final weightcontroller = TextEditingController();
  final gendercontroller = SingleValueDropDownController();
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
  late String weight;
  late String height;
  late String bmi;
  late String gender;

  getData() {
    name = getName();
    weight = getWeight();
    height = getHeight();
    gender = getGender();
    bmi = getbmi();
  }

  singout() async {
    await FirebaseAuth.instance.signOut();
  }

  bool isLoading = true;
  late String name;
  @override
  void initState() {
    edit = false;
    super.initState();
    isLoading = true;
    UserDB().RefreshData().whenComplete(() {
      getData();
      setState(() {
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

        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? CircularProgressIndicator()
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
                                            Text(
                                              'You Are ${_image[id]}',
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Gender',
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
                              ? DropDownTextField(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                  ),
                                  listTextStyle: TextStyle(
                                    color: Colors.white70,
                                  ),
                                  controller: gendercontroller,
                                  clearOption: true,
                                  dropdownColor: Colors.black,
                                  textFieldDecoration: InputDecoration(
                                    hintText: gender,
                                    border: InputBorder.none,
                                    fillColor: Colors.blue,
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return "Required field";
                                    } else {
                                      print(
                                          gendercontroller.dropDownValue!.name);

                                      return null;
                                    }
                                  },
                                  dropDownItemCount: 2,
                                  dropDownList: const [
                                    DropDownValueModel(
                                        name: 'Male', value: "Male"),
                                    DropDownValueModel(
                                      name: 'Female',
                                      value: "Female",
                                    ),
                                  ],
                                  onChanged: (val) {
                                    setState(() {
                                      print(val);
                                    });
                                  },
                                )
                              : Text(
                                  gender,
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
                                        isLoading = true;
                                        if (namecontroller.text.isEmpty ||
                                            weightcontroller.text.isEmpty ||
                                            heightcontroller.text.isEmpty ||
                                            gendercontroller.dropDownValue ==
                                                null) {
                                          Get.snackbar("Error",
                                              "Please fill in all fields.",
                                              colorText: Colors.black);
                                          return;
                                        }
                                        await UserDB()
                                            .addUserDetail(
                                                namecontroller.text,
                                                weightcontroller.text,
                                                heightcontroller.text,
                                                gendercontroller
                                                    .dropDownValue!.value)
                                            .whenComplete(() {
                                          setState(() {
                                            getData();
                                            edit = false;
                                            isLoading = false;
                                          });
                                        });
                                      } else
                                        setState(() {
                                          edit = true;
                                        });
                                    } catch (e) {
                                      Get.snackbar("Error", e.toString(),
                                          colorText: Primary_green);
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
                                          })
                                        : singout();
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
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
