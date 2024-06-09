import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nourish_me/database/databaseuser.dart';
import 'package:nourish_me/functions/repeatfunction.dart';
import 'package:nourish_me/geminiapi/gemini.dart';
import 'package:nourish_me/constants/Constants.dart';

final databaseref = FirebaseDatabase.instance.ref('UserDetails');
final user = FirebaseAuth.instance.currentUser;
final databasecal = FirebaseDatabase.instance.ref('caloriesvalue');

abstract class userdatafunction {
  Future<void> addCalories(
    String name,
    String _selectedDate,
  );
  Future<CaloriesListItem> getCaloriesvalue(String Value, String _selectedDate);
  Future<List<CaloriesListItem>> getList(String _selectedDate);
  Future<void> addTodayCalorie(
      String _selectedDate, String TodayCalories, String TargetCalorie);
  Future<String> getTodayCalorie(String _selectedDate);
  Future<String> getTargetCalorie(String _selectedDate);
  Future<void> deleteCalories(String id, String _selectedDate);
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
          .child('${user!.uid}/${_selectedDate}/calories/List/')
          .get();
      if (userdetail.exists) {
        // ignore: unused_local_variable
        int index = 0;
        for (final child in userdetail.children) {
          userDetails.add(await getCaloriesvalue(child.key, _selectedDate));
          index++;
        }
      }
      late String todaycalorie;
      int totalCalories = 0;

      if (_selectedDate == ParsedateDB(DateTime.now())) {
        todaycalorie = getTotalCalorie();
        print('success inside add calorie sum finding');
      } else {
        todaycalorie = await getTodayCalorie(_selectedDate);
      }
      for (var item in userDetails) {
        if (double.tryParse(item.calorie!) != null) {
          totalCalories += int.parse(item.calorie!);
        }
      }
      addTodayCalorie(_selectedDate, totalCalories.toString(), todaycalorie);
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
          .child('${user!.uid}/${_selectedDate}/calories/List/${Value}')
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
  Future<void> addCalories(
    String name,
    String _selectedDate,
  ) async {
    String? Calories;
    try {
      final databasecalories = await databasecal.get();
      print(databasecalories);
      String data = await databasecalories
          .child('${name.toLowerCase()}')
          .value
          .toString();
      if (data != 'null') {
        Calories = data;
      } else {
        Calories = await await Geminifunction().Caloriesvalue('$name');
      }
      String time = DateTime.now().millisecondsSinceEpoch.toString();
      await databaseref
          .child('${user!.uid}/${_selectedDate}/calories/List/${time}')
          .set({
        'id': '${time}',
        'name': name,
        'calorie': Calories,
      });
      getList(_selectedDate);
      print('UserDetails added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code, colorText: Primary_green);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  @override
  Future<void> deleteCalories(String id, String _selectedDate) async {
    try {
      await databaseref
          .child('${user!.uid}/${_selectedDate}/calories/List/${id}')
          .remove();
      print(id);
      print('UserDetails deleted successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.code, colorText: Primary_green);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  @override
  Future<void> addTodayCalorie(
      String _selectedDate, String TodayCalories, String TargetCalorie) async {
    try {
      await databaseref
          .child('${user!.uid}/${_selectedDate}/calories/today')
          .set({
        'todayCalorie': TodayCalories,
        'targetCalorie': TargetCalorie,
      });
      print('today calories is added');
    } catch (e) {
      print('error in adding today calories');
      throw e;
    }
  }

  @override
  Future<String> getTodayCalorie(String _selectedDate) async {
    late String Values;

    try {
      final calories = await databaseref
          .child('${user!.uid}/${_selectedDate}/calories/today/')
          .get();

      if (calories.exists) {
        Values = calories.child('todayCalorie').value.toString();
      } else {
        Values = '0';
      }
    } catch (e) {
      print('error in geting  today calories');
      throw e;
    }
    return Values;
  }

  @override
  Future<String> getTargetCalorie(String _selectedDate) async {
    late String Values;
    try {
      final calories = await databaseref
          .child('${user!.uid}/${_selectedDate}/calories/today/')
          .get();

      if (calories.exists) {
        Values = calories.child('targetCalorie').value.toString();
        print('target working');
        return Values;
      }
    } catch (e) {
      print('error in geting target calories');
      throw e;
    }
    return '0';
  }
}
