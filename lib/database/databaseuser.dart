import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:nourish_me/theme_library/theme_library.dart';

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
  Future<void> addUserDetail(
      String name, String weight, String tweight, String height, String gender);
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
        ]);
      }
    } catch (error) {
      print('Error getting user details: $error');
    }
    return userDetails;
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
    } else {
      return null;
    }
  }

  @override
  Future<void> addUserDetail(String name, String weight, String tweight,
      String height, String gender) async {
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
        'tweight': tweight,
      });
      await RefreshData();
      print('UserDetails added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code, colorText: Primary_green);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  @override
  Future<void> addTargetWeight(
    String weight,
  ) async {
    try {
      await databaseref.child('${user!.uid}/tweight').set(
            weight,
          );
      await RefreshData();
      print('Target Weight added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code, colorText: Primary_green);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  @override
  Future<void> addCurrentWeight(
    String weight,
  ) async {
    try {
      await databaseref.child('${user!.uid}/weight').set(
            weight,
          );
      await RefreshData();
      print('Current Weight added successfully with email: ${user!.email}');
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

String getGender() {
  return UserDB()._gender!;
}
