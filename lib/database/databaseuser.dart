import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

final databaseref = FirebaseDatabase.instance.ref('User');
final user = FirebaseAuth.instance.currentUser;

abstract class userdatafunction {
  Future<void> RefreshData();
  Future<void> addTargetWeight(
    String weight,
  );
  Future<void> addCurrentWeight(
    String weight,
  );
  Future<void> addUserDetail(String name, String weight, String tweight,
      String height, String age, String gender);
}

class UserDB implements userdatafunction {
  UserDB._internal();
  static UserDB instances = UserDB._internal();

  factory UserDB() {
    return instances;
  }

  String? _name;
  String _weight = '20';
  String? _height;
  String? _bmi;
  String? _gender;
  String _tweight = '20';
  String? _age;
  String? _Calorie;
  String? _exersice;
  String? _noofday;

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
          userdetail.child('tweight').value.toString(),
          userdetail.child('age').value.toString(),
          userdetail.child('exercise').value.toString(),
        ]);
        final String noofday;

        final String Calorie;
        final bmr =
            BMR(userDetails[2], userDetails[2], userDetails[6], userDetails[3]);
        final ttde = TTDE(userDetails[7], bmr);
        final int weight_difference =
            int.parse(userDetails[5]) - int.parse(userDetails[2]);
        if (weight_difference > 0) {
          Calorie = ((ttde * 110).round()).toString();

          noofday = (weight_difference.round()).toString();
        } else if (weight_difference < 0) {
          Calorie = ((ttde - 500).round()).toString();
          noofday = (((weight_difference * -1) * 0.453592).round()).toString();
        } else {
          Calorie = ttde.toString();
          noofday = '0';
        }
        addCaloriesInside(Calorie);
        addnoofdayInside(noofday);
        userDetails.add(
          noofday,
        );
        userDetails.add(
          Calorie,
        );
      }
    } catch (error) {
      print('Error getting user details: $error');
    }
    return userDetails;
  }

  Future<void> addCaloriesInside(
    String Calories,
  ) async {
    try {
      await databaseref.child('${user!.uid}/Calorie').set(
            Calories,
          );
      print('Refreshed Calorie added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  Future<void> addnoofdayInside(
    String Calories,
  ) async {
    try {
      await databaseref.child('${user!.uid}/noofday').set(
            Calories,
          );
      print('Refreshed Calorie added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  @override
  Future<void> RefreshData() async {
    final userDetails = await getUserDetails();

    if (userDetails.isNotEmpty) {
      _name = userDetails[0];
      _height = userDetails[1];
      _weight = userDetails[2];
      _gender = userDetails[3];
      _bmi = userDetails[4];
      _tweight = userDetails[5];
      _age = userDetails[6];
      _exersice = userDetails[7];
      _noofday = userDetails[8];
      _Calorie = userDetails[9];
    } else {
      return null;
    }
  }

  double BMR(String weight, String height, String age, String gender) {
    double bmr;
    if (gender == 'Male') {
      bmr = ((13.75 * double.parse(weight)) +
          (5.003 * double.parse(height)) -
          (6.75 * double.parse(age)) +
          66.5);
    } else {
      bmr = ((9.563 * double.parse(weight)) +
          (1.850 * double.parse(height)) -
          (4.676 * double.parse(age)) +
          665.1);
    }
    return bmr;
  }

  double TTDE(String exercise, double bmr) {
    double ttde;
    if (exercise == 'ea') {
      ttde = bmr * 1.9;
    } else if (exercise == 'l') {
      ttde = bmr * 1.2;
    } else if (exercise == 'la') {
      ttde = bmr * 1.375;
    } else if (exercise == 'ma') {
      ttde = bmr * 1.55;
    } else if (exercise == 'va') {
      ttde = bmr * 1.725;
    } else
      ttde = bmr;
    return ttde;
  }

  @override
  Future<void> addUserDetail(String name, String weight, String tweight,
      String height, String age, String gender) async {
    try {
      final String exercise = 'l';

      final bmi = (10000 *
              (int.parse(weight) / (int.parse(height) * int.parse(height))))
          .round();
      await databaseref.child('${user!.uid}').set({
        'name': name,
        'height': height,
        'weight': weight,
        'gender': gender,
        'bmi': bmi,
        'tweight': tweight,
        'age': age,
        'exercise': exercise,
      });
      await RefreshData();
      print('UserDetails added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  @override
  Future<void> addTargetWeight(
    String weight,
  ) async {
    try {
      await addUserDetail(_name!, _weight, weight, _height!, _age!, _gender!);
      print('Target Weight added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  @override
  Future<void> addCurrentWeight(
    String weight,
  ) async {
    try {
      await addUserDetail(_name!, weight, _tweight, _height!, _age!, _gender!);
      print('Current Weight added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding name: $error');
    }
  }
}

String getName() {
  return UserDB()._name!;
}

String getWeight() {
  return UserDB()._weight;
}

String getTWeight() {
  return UserDB()._tweight;
}

String getHeight() {
  return UserDB()._height!;
}

String getbmi() {
  return UserDB()._bmi!;
}

String getAge() {
  return UserDB()._age!;
}

String getGender() {
  return UserDB()._gender!;
}

String getTotalCalorie() {
  return UserDB()._Calorie!;
}

String getnoofday() {
  return UserDB()._noofday!;
}

String getexercisetype() {
  return UserDB()._exersice!;
}
