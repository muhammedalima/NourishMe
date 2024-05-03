import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourish_me/theme_library/theme_library.dart';

final databaseref = FirebaseDatabase.instance.ref('UserDetails');
final user = FirebaseAuth.instance.currentUser;

abstract class userdatafunction {
  Future<void> addCalories(String name, String _selectedDate);
  Future<CaloriesListItem> getCaloriesvalue(String Value, String _selectedDate);
  Future<List<CaloriesListItem>> getList(String _selectedDate);
}

class CaloriesListItem {
  String? id;
  String? name;
  String? calorie;

  CaloriesListItem({this.id, this.name, this.calorie});

  String toString() {
    return '{$name $calorie $id}';
  }
}

class CaloriesList {
  List<CaloriesListItem>? caloriesList;

  CaloriesList({this.caloriesList});

  String toString() {
    return '{$caloriesList}';
  }
}

class CaloriesDB implements userdatafunction {
  CaloriesDB._internal();
  static CaloriesDB instances = CaloriesDB._internal();

  factory CaloriesDB() {
    return instances;
  }
  ValueNotifier<CaloriesListItem> userList = ValueNotifier(CaloriesListItem());

  @override
  Future<List<CaloriesListItem>> getList(String _selectedDate) async {
    List<CaloriesListItem> userDetails = [];
    try {
      final userdetail = await databaseref
          .child('${user!.uid}/${_selectedDate}/calories')
          .get();
      if (userdetail.exists) {
        // Iterate through child nodes and fetch calorie information
        int index = 0;
        for (final child in userdetail.children) {
          userDetails.add(await getCaloriesvalue(child.key, _selectedDate));
          index++;
        }
      }
    } catch (error) {
      print('Error getting user details: $error');
    }
    return userDetails;
  }

  @override
  Future<CaloriesListItem> getCaloriesvalue(
      String? Value, String _selectedDate) async {
    CaloriesListItem userDetails = CaloriesListItem();
    try {
      final userdetail = await databaseref
          .child('${user!.uid}/${_selectedDate}/calories/${Value}')
          .get();
      if (userdetail.exists) {
        userDetails = CaloriesListItem(
            id: userdetail.child('id').value.toString(),
            name: userdetail.child('name').value.toString(),
            calorie: userdetail.child('calorie').value.toString());

        return await userDetails;
      }
    } catch (error) {
      print('Error getting user details: $error');
    }
    return userDetails;
  }

  @override
  Future<void> addCalories(String name, String _selectedDate) async {
    try {
      await databaseref
          .child(
              '${user!.uid}/${_selectedDate}/calories/${(DateTime.now().millisecondsSinceEpoch).toString()}')
          .set({
        'id': '${(DateTime.now().millisecondsSinceEpoch).toString()}',
        'name': name,
        'Calories': '20',
      });
      print('UserDetails added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code, colorText: Primary_green);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  Future<void> deleteCalories(String id, String _selectedDate) async {
    try {
      await databaseref
          .child('${user!.uid}/${_selectedDate}/calories/${id}')
          .remove();
      // await RefreshData();
      print('UserDetails added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code, colorText: Primary_green);
    } catch (error) {
      print('Error adding name: $error');
    }
  }
}
