import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

final databaseref = FirebaseDatabase.instance.ref('User');
final user = FirebaseAuth.instance.currentUser;

abstract class userdatafunction {
  Future<void> RefreshData();
  Future<void> addTargetWeight(String weight);
  Future<void> addCurrentWeight(String weight);
  Future<void> addUserDetail(String name, String weight, String tweight,
      String height, String age, String gender, {String? activityLevel});
  Future<void> setOnboardingComplete(bool isComplete);
  Future<bool> isOnboardingComplete();
  Future<void> updateActivityLevel(String activityLevel);
  Future<Map<String, dynamic>> getNutritionData();
  Future<void> logFoodItem(String name, int calories, String mealType);
  Future<void> setWeightGoal(String goal);
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
  bool? _isOnboardingComplete;
  String? _activityLevel;
  String? _weightGoal;

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
        
        // Get activity level
        _activityLevel = userdetail.child('activity_level').exists
            ? userdetail.child('activity_level').value.toString()
            : 'lightly active';
            
        // Get weight goal
        _weightGoal = userdetail.child('weight_goal').exists
            ? userdetail.child('weight_goal').value.toString()
            : 'maintain';

        final String noofday;
        final String Calorie;
        
        final bmr = BMR(userDetails[2], userDetails[1], userDetails[6], userDetails[3]);
        final ttde = TTDE(userDetails[7], bmr);
        final int weight_difference = int.parse(userDetails[5]) - int.parse(userDetails[2]);
        
        if (weight_difference > 0) {
          Calorie = ((ttde * 1.1).round()).toString();
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
        userDetails.add(noofday);
        userDetails.add(Calorie);
        
        // Retrieve onboarding status
        _isOnboardingComplete = userdetail.child('isOnboardingComplete').exists
            ? userdetail.child('isOnboardingComplete').value as bool
            : false;
      }
    } catch (error) {
      print('Error getting user details: $error');
    }
    return userDetails;
  }

  Future<void> addCaloriesInside(String Calories) async {
    try {
      await databaseref.child('${user!.uid}/Calorie').set(Calories);
      print('Refreshed Calorie added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding calorie: $error');
    }
  }

  Future<void> addnoofdayInside(String Calories) async {
    try {
      await databaseref.child('${user!.uid}/noofday').set(Calories);
      print('Refreshed noofday added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding noofday: $error');
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
      String height, String age, String gender, {String? activityLevel}) async {
    try {
      final String exercise = activityLevel ?? 'l';
      _activityLevel = convertExerciseCodeToReadable(exercise);

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
        'activity_level': _activityLevel,
        'weight_goal': _weightGoal ?? 'maintain',
        'isOnboardingComplete': _isOnboardingComplete ?? false,
      });
      await RefreshData();
      print('UserDetails added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding name: $error');
    }
  }

  String convertExerciseCodeToReadable(String code) {
    switch (code) {
      case 'l':
        return 'sedentary';
      case 'la':
        return 'lightly active';
      case 'ma':
        return 'moderately active';
      case 'va':
        return 'very active';
      case 'ea':
        return 'extra active';
      default:
        return 'lightly active';
    }
  }

  String convertReadableToExerciseCode(String readable) {
    switch (readable.toLowerCase()) {
      case 'sedentary':
        return 'l';
      case 'lightly active':
        return 'la';
      case 'moderately active':
        return 'ma';
      case 'very active':
        return 'va';
      case 'extra active':
        return 'ea';
      default:
        return 'la';
    }
  }

  @override
  Future<void> addTargetWeight(String weight) async {
    try {
      await addUserDetail(_name!, _weight, weight, _height!, _age!, _gender!);
      print('Target Weight added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding target weight: $error');
    }
  }

  @override
  Future<void> addCurrentWeight(String weight) async {
    try {
      await addUserDetail(_name!, weight, _tweight, _height!, _age!, _gender!);
      print('Current Weight added successfully with email: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error adding current weight: $error');
    }
  }
  
  @override
  Future<void> setOnboardingComplete(bool isComplete) async {
    try {
      await databaseref.child('${user!.uid}/isOnboardingComplete').set(isComplete);
      _isOnboardingComplete = isComplete;
      print('Onboarding status set to $isComplete for user: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error setting onboarding status: $error');
    }
  }
  
  @override
  Future<bool> isOnboardingComplete() async {
    try {
      final snapshot = await databaseref.child('${user!.uid}/isOnboardingComplete').get();
      if (snapshot.exists) {
        return snapshot.value as bool;
      }
      return false;
    } catch (error) {
      print('Error checking onboarding status: $error');
      return false;
    }
  }

  @override
  Future<void> updateActivityLevel(String activityLevel) async {
    try {
      final exercise = convertReadableToExerciseCode(activityLevel);
      await databaseref.child('${user!.uid}/activity_level').set(activityLevel);
      await databaseref.child('${user!.uid}/exercise').set(exercise);
      _activityLevel = activityLevel;
      _exersice = exercise;
      print('Activity level updated to $activityLevel for user: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error updating activity level: $error');
    }
  }

  @override
  Future<Map<String, dynamic>> getNutritionData() async {
    try {
      final userdetail = await databaseref.child('${user!.uid}').get();
      if (!userdetail.exists) {
        return {};
      }

      final Map<String, dynamic> nutritionData = {};
      
      // Get food log data if it exists
      final foodLogSnapshot = await databaseref.child('${user!.uid}/food_log').get();
      if (foodLogSnapshot.exists) {
        nutritionData['food_log'] = foodLogSnapshot.value;
      } else {
        nutritionData['food_log'] = [];
      }
      
      // Get total daily calories
      if (userdetail.child('Calorie').exists) {
        nutritionData['daily_target_calories'] = userdetail.child('Calorie').value;
      }
      
      return nutritionData;
    } catch (error) {
      print('Error getting nutrition data: $error');
      return {};
    }
  }

  @override
  Future<void> logFoodItem(String name, int calories, String mealType) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final foodItem = {
        'name': name,
        'calories': calories,
        'meal_type': mealType,
        'timestamp': timestamp,
        'date': DateTime.now().toString().split(' ')[0], // YYYY-MM-DD format
      };

      final foodLogRef = databaseref.child('${user!.uid}/food_log/$timestamp');
      await foodLogRef.set(foodItem);
      
      print('Food item logged: $name with $calories calories');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error logging food item: $error');
    }
  }

  @override
  Future<void> setWeightGoal(String goal) async {
    try {
      await databaseref.child('${user!.uid}/weight_goal').set(goal);
      _weightGoal = goal;
      print('Weight goal set to $goal for user: ${user!.email}');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Oops', e.code);
    } catch (error) {
      print('Error setting weight goal: $error');
    }
  }
  
  // Method to get today's consumed calories from food log
  Future<int> getTodayCalories() async {
    try {
      final today = DateTime.now().toString().split(' ')[0]; // YYYY-MM-DD format
      final foodLogSnapshot = await databaseref.child('${user!.uid}/food_log').get();
      
      if (!foodLogSnapshot.exists) {
        return 0;
      }
      
      int totalCalories = 0;
      final Map<dynamic, dynamic> foodLog = foodLogSnapshot.value as Map<dynamic, dynamic>;
      
      foodLog.forEach((key, value) {
        if (value is Map && value.containsKey('date') && value.containsKey('calories')) {
          if (value['date'] == today) {
            totalCalories += (value['calories'] as int);
          }
        }
      });
      
      return totalCalories;
    } catch (error) {
      print('Error getting today\'s calories: $error');
      return 0;
    }
  }
}

// Getter functions
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

String getActivityLevel() {
  return UserDB()._activityLevel ?? 'lightly active';
}

String getWeightGoal() {
  return UserDB()._weightGoal ?? 'maintain';
}

bool getOnboardingStatus() {
  return UserDB()._isOnboardingComplete ?? false;
}

// Helper class for Gemini database integration
class DatabaseHelper {
  DatabaseHelper._internal();
  static DatabaseHelper instance = DatabaseHelper._internal();
  
  Future<List<Map<String, dynamic>>> getTotalCalories() async {
    try {
      final totalCal = await UserDB().getTodayCalories();
      return [{'totalcalories': totalCal}];
    } catch (e) {
      print('Error in DatabaseHelper.getTotalCalories: $e');
      return [{'totalcalories': 0}];
    }
  }
  
  Future<List<Map<String, dynamic>>> getUserDetails() async {
    try {
      // Get user details to pass to Gemini
      await UserDB().RefreshData();
      
      return [{
        'age': int.tryParse(getAge()) ?? 30,
        'gender': getGender(),
        'weight': int.tryParse(getWeight()) ?? 70,
        'height': int.tryParse(getHeight()) ?? 170,
        'activity_level': getActivityLevel(),
        'weight_goal': getWeightGoal(),
      }];
    } catch (e) {
      print('Error in DatabaseHelper.getUserDetails: $e');
      return [];
    }
  }
}