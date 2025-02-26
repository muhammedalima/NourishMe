import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:nourish_me/constants/Constants.dart';
import 'package:nourish_me/database/databaseuser.dart';

class Geminifunction {
  Geminifunction()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: Geminiapi,
        );

  final GenerativeModel _model;

  Future<String> Caloriesvalue(String name) async {
    try {
      // Improve prompt for better calorie estimation
      final caloriesResponse = await FoodCalories(name);
      
      if (caloriesResponse == null || caloriesResponse.isEmpty) {
        print('Error: Empty response from FoodCalories');
        return await fallbackCalorieEstimation(name);
      }
      
      try {
        final jsonData = jsonDecode(caloriesResponse);
        if (jsonData is Map && jsonData.containsKey('Calories')) {
          final caloriesValue = jsonData['Calories'] as String;
          if (caloriesValue == 'error' || caloriesValue.isEmpty) {
            return await fallbackCalorieEstimation(name);
          }
          return caloriesValue;
        }
        print('Invalid JSON schema: $caloriesResponse');
        return await fallbackCalorieEstimation(name);
      } catch (jsonError) {
        print('JSON parsing error: $jsonError');
        return await fallbackCalorieEstimation(name);
      }
    } on GenerativeAIException catch (e) {
      print('GenerativeAI Exception: ${e.message}');
      return await fallbackCalorieEstimation(name);
    } catch (e) {
      print('Unexpected error in Caloriesvalue: $e');
      return await fallbackCalorieEstimation(name);
    }
  }

  // Add a fallback method for calorie estimation that uses a different prompt
  Future<String> fallbackCalorieEstimation(String name) async {
    try {
      final prompt = '''
You are a nutrition expert specializing in calorie content.
I need the approximate calories per serving of: $name
Be very specific and accurate. If you're uncertain, provide your best estimate based on similar foods.
Return ONLY a JSON object with this schema: {"Calories": "number"} 
The value should be a whole number without any text or units.
Example output: {"Calories": "250"}
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      if (response.text == null || response.text!.isEmpty) {
        print('Empty response from fallback calorie estimation');
        return getDefaultCalorieForFood(name);
      }
      
      try {
        final jsonData = jsonDecode(response.text!);
        if (jsonData is Map && jsonData.containsKey('Calories')) {
          return jsonData['Calories'] as String;
        }
        print('Invalid JSON from fallback: ${response.text}');
        return getDefaultCalorieForFood(name);
      } catch (jsonError) {
        print('JSON error in fallback: $jsonError');
        return getDefaultCalorieForFood(name);
      }
    } catch (e) {
      print('Error in fallback calorie estimation: $e');
      return getDefaultCalorieForFood(name);
    }
  }

  // Get a more accurate default calorie based on food category
  String getDefaultCalorieForFood(String name) {
    // Common food categories and their average calories
    final Map<List<String>, String> foodCategories = {
      ['apple', 'banana', 'orange', 'fruit', 'berries']: '80',
      ['rice', 'pasta', 'bread', 'noodles', 'grain']: '150',
      ['chicken', 'beef', 'pork', 'fish', 'meat']: '200',
      ['yogurt', 'milk', 'cheese', 'dairy']: '120',
      ['cookie', 'cake', 'dessert', 'sweet', 'chocolate']: '300',
      ['salad', 'vegetable', 'carrot', 'broccoli']: '50',
      ['soup', 'stew']: '120',
      ['sandwich', 'burger', 'pizza']: '350',
      ['drink', 'beverage', 'juice', 'soda']: '100',
    };

    final lowercaseName = name.toLowerCase();
    
    for (final category in foodCategories.entries) {
      for (final keyword in category.key) {
        if (lowercaseName.contains(keyword)) {
          return category.value;
        }
      }
    }
    
    // If no category matches, return a more reasonable default than 60
    return '150';
  }

  Future<String> FindName(Uint8List image) async {
    try {
      final response = await validateImage(image);

      if (response == null || response == '') {
        throw const GeminierrorException('Response is empty');
      }

      if (jsonDecode(response) case {'name': String name}) return name;
      throw const GeminierrorException('Invalid JSON schema');
    } on GenerativeAIException {
      throw const GeminierrorException(
        'Problem with the Generative AI service',
      );
    } catch (e) {
      if (e is GeminierrorException) rethrow;

      throw const GeminierrorException();
    }
  }

  Future<String?> FoodCalories(String name) async {
    final prompt = '''
You are a nutrition expert specializing in calorie content.
I need the approximate calories per serving of: $name
Be very specific and accurate. Research-based values are preferred.
Return ONLY a JSON object with this schema: {"Calories": "number"} 
The value should be a whole number without any text or units.
Example: If $name has between 300-400 calories, use the midpoint value: {"Calories": "350"}
If you cannot determine calories for this item, respond with: {"Calories": "error"}
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text;
  }

  Future<String?> validateImage(Uint8List image) async {
    final prompt = '''
You are a food identification expert who can identify any food item from an image.
Identify only food items - ignore non-food objects like water bottles or matchboxes.
Be specific - for example, instead of just "rice", specify "fried rice" if visible.
If you cannot identify a food item, respond with: {"name": "error"}
Provide your response ONLY as a JSON object with this schema: {"name": "food name"}
''';

    final response = await _model.generateContent([
      Content.multi([TextPart(prompt), DataPart('image/jpeg', image)]),
    ]);

    return response.text;
  }

  // Get total calories consumed
  Future<String> getTotalCalorie() async {
    try {
      List<Map<String, dynamic>> cal = await DatabaseHelper.instance.getTotalCalories();
      int totalCalories = 0;
      
      for (var entry in cal) {
        if (entry.containsKey('totalcalories')) {
          totalCalories += entry['totalcalories'] as int;
        }
      }
      
      return totalCalories.toString();
    } catch (e) {
      print('Error getting total calories: $e');
      return "0"; // Return 0 as default if there's an error
    }
  }
  
  // Get recommended daily calorie intake
  Future<String> getRecommendedCalories() async {
    try {
      // Get user details from database
      final userDetails = await DatabaseHelper.instance.getUserDetails();
      
      if (userDetails.isEmpty) {
        return "2000"; // Default recommendation if no user details
      }
      
      // Extract user data
      final Map<String, dynamic> user = userDetails.first;
      final int? age = user['age'] as int?;
      final String? gender = user['gender'] as String?;
      final int? weight = user['weight'] as int?;
      final int? height = user['height'] as int?;
      final String? activityLevel = user['activity_level'] as String?;
      
      // If we don't have all required data, use default
      if (age == null || gender == null || weight == null || height == null || activityLevel == null) {
        return "2000";
      }
      
      // Calculate BMR (Basal Metabolic Rate) using Mifflin-St Jeor Equation
      double bmr;
      if (gender.toLowerCase() == 'male') {
        bmr = 10 * weight + 6.25 * height - 5 * age + 5;
      } else {
        bmr = 10 * weight + 6.25 * height - 5 * age - 161;
      }
      
      // Apply activity multiplier
      double activityMultiplier;
      switch (activityLevel.toLowerCase()) {
        case 'sedentary':
          activityMultiplier = 1.2;
          break;
        case 'lightly active':
          activityMultiplier = 1.375;
          break;
        case 'moderately active':
          activityMultiplier = 1.55;
          break;
        case 'very active':
          activityMultiplier = 1.725;
          break;
        case 'extra active':
          activityMultiplier = 1.9;
          break;
        default:
          activityMultiplier = 1.2;
      }
      
      // Calculate recommended daily calories
      int recommendedCalories = (bmr * activityMultiplier).round();
      
      return recommendedCalories.toString();
    } catch (e) {
      print('Error calculating recommended calories: $e');
      return "2000"; // Default recommendation if there's an error
    }
  }

  Future<String?> Reciepe() async {
    print('/////////////Started Recipe Generation////////////////');
    try {
      final totalcalorie = await getTotalCalorie();
      final recommendedCalories = await getRecommendedCalories();
      
      final int consumed = int.tryParse(totalcalorie) ?? 0;
      final int recommended = int.tryParse(recommendedCalories) ?? 2000;
      final int remaining = recommended - consumed;
      
      String calorieGuidance = "";
      if (remaining <= 0) {
        calorieGuidance = "You've already consumed your recommended daily calories. This recipe is a light, nutritious option.";
      } else if (remaining < 300) {
        calorieGuidance = "You have a small amount of calories remaining. This recipe is a light, satisfying option.";
      } else if (remaining < 600) {
        calorieGuidance = "You have a moderate amount of calories remaining. This recipe provides a balanced meal option.";
      } else {
        calorieGuidance = "You have plenty of calories remaining. This recipe is nutritious and filling.";
      }
      
      final prompt = '''
You are NourishNavi, a chef who travels the world and creates recipes inspired by your journeys.

Create a recipe based on the following nutritional information:
- Calories consumed today: $consumed
- Recommended daily intake: $recommended
- Calories remaining: $remaining
- Guidance: $calorieGuidance

Format the recipe with clear sections:
1. A creative recipe title at the top
2. INGREDIENTS: List all ingredients with quantities
3. INSTRUCTIONS: Numbered, step-by-step cooking directions
4. STORY: A short, personal travel story that inspired this recipe
5. ALLERGENS: List of common allergens present in the recipe
6. NUTRITION: Nutritional info including calories per serving and servings

Guidelines:
- Create a recipe appropriate for the remaining calories
- Use only real, edible ingredients
- Ensure food safety (e.g., properly cooked meat temperatures)
- Include common pantry ingredients when possible
- Make recipe culturally authentic if based on a specific cuisine
- Structure the recipe clearly with section headers

Adjust the recipe based on remaining calories:
- If under 300 calories remaining: Create a light snack or mini-meal
- If 300-600 calories remaining: Create a moderate balanced meal
- If over 600 calories remaining: Create a more substantial meal
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      
      if (response.text == null || response.text!.isEmpty) {
        throw Exception("Empty response from Gemini API");
      }
      
      return response.text;
    } catch (e) {
      print('Error generating recipe: $e');
      // Return a fallback recipe if generation fails
      return '''
Simple Homemade Recipe

INGREDIENTS:
- 2 cups of mixed vegetables (carrots, peas, corn)
- 1 cup rice or pasta
- 2 tablespoons olive oil
- Salt and pepper to taste
- 1 cup protein of choice (chicken, tofu, or beans)
- 1 teaspoon mixed herbs

INSTRUCTIONS:
1. Cook the rice or pasta according to package instructions.
2. In a pan, heat the olive oil and add your protein of choice.
3. Add the vegetables and cook until tender.
4. Season with salt, pepper, and herbs.
5. Combine with the cooked rice or pasta and serve.

STORY:
This simple recipe reminds me of the comfort foods I discovered while visiting small towns across different countries. Sometimes the simplest meals bring the most joy.

ALLERGENS:
May contain gluten if using wheat pasta.

NUTRITION:
Serves 2. Approximately 350-450 calories per serving depending on protein choice.
''';
    }
  }
}

class GeminierrorException implements Exception {
  const GeminierrorException([this.message = 'Unknown problem']);

  final String message;

  @override
  String toString() => 'GeminierrorException: $message';
}