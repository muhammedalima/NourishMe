import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:nourish_me/theme_library/theme_library.dart';

final databaseref = FirebaseDatabase.instance.ref('User');
final user = FirebaseAuth.instance.currentUser;

Future<List<String>> getUserDetails() async {
  List<String> userDetails = [];
  try {
    final userdetail = await databaseref.child('${user!.uid}').get();
    if (userdetail.exists) {
      userDetails.addAll([
        userdetail.child('name').value.toString(),
        userdetail.child('height').value.toString(),
        userdetail.child('weight').value.toString(),
        userdetail.child('gender').value.toString(),
        userdetail.child('bmi').value.toString(),
      ]);
      UserDB().RefreshData();
    }
  } catch (error) {
    print('Error getting user details: $error');
  }
  return userDetails;
}

abstract class userdatafunction {
  Future<void> RefreshData();
  Future<void> addUserDetail(
      String name, String weight, String height, String gender);
}

class UserDB implements userdatafunction {
  UserDB._internal();
  static UserDB instances = UserDB._internal();

  factory UserDB() {
    return instances;
  }

  String? _name;
  String? _weight;
  String? _height;
  String? _bmi;
  String? _gender;

  @override
  Future<void> RefreshData() async {
    final userDetails = await getUserDetails();
    if (userDetails.isNotEmpty) {
      _name = userDetails[0];
      _height = userDetails[1];
      _weight = userDetails[2];
      _gender = userDetails[3];
      _bmi = userDetails[4];
    } else {
      return null;
    }
  }

  @override
  Future<void> addUserDetail(
      String name, String weight, String height, String gender) async {
    try {
      final bmi = (10000 *
              (int.parse(weight) / (int.parse(height) * int.parse(height))))
          .round();
      await databaseref.child('${user!.uid}').set({
        'name': name,
        'height': height,
        'weight': weight,
        'gender': gender,
        'bmi': bmi,
      });
      RefreshData();
      print('UserDetails added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code, colorText: Primary_green);
    } catch (error) {
      print('Error adding name: $error');
    }
  }
}

String getName() {
  return UserDB()._name!;
}

String getWeight() {
  return UserDB()._weight!;
}

String getHeight() {
  return UserDB()._height!;
}

String getbmi() {
  return UserDB()._bmi!;
}

String getGender() {
  return UserDB()._gender!;
}
