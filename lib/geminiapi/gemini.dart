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
    String? calories;
    try {
      final calories = await FoodCalories(name);
      if (calories == null) {
        print('error');
      }
      final jsonData = jsonDecode(calories!);
      if (jsonData is Map && jsonData.containsKey('Calories')) {
        final caloriesValue = jsonData['Calories'] as String;
        return caloriesValue;
      }
      throw const GeminierrorException('Invalid JSON schema');
    } on GenerativeAIException {
      throw const GeminierrorException(
        'Problem with the Generative AI service',
      );
    } catch (e) {
      if (e is GeminierrorException) rethrow;
      print('/////////////// ERROR EXECPTION //////////////////');
      return '60';
    }
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
    final prompt =
        'your a calorie find find calorie of food items just by its name'
        'Your find the average calories of the food'
        'Provide your response as a JSON object with the following schema: {"Calories": ""}.'
        'Only JSON object is needed.'
        'your output must be an single value.'
        'example if biriyani have 300-400 calorie then set Calories as 350.'
        'find the calorie of the food = ${name}.'
        'If you doesnot find food calorie set calorie as error';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text;
  }

  Future<String?> validateImage(Uint8List image) async {
    final prompt =
        'You are a food finding expert you can fing any food item just by looking into image.'
        'You have given with a food item identify the food item'
        'You are only allowed to tell the food item name no other names are allowed like waterbottle,matchbox'
        'If you doesnot find a food item set food name as error'
        'Provide your response as a JSON object with the following schema: {"name": ""}.';

    final response = await _model.generateContent([
      Content.multi([TextPart(prompt), DataPart('image/jpeg', image)]),
    ]);

    return response.text;
  }

  Future<String?> Reciepe() async {
    print('/////////////Started////////////////');
    final totalcalorie = await getTotalCalorie();
    final prompt = '''
    You are a NourishNavi who's a chef that travels around the world a lot, and your travels inspire recipes.
    
    Recommend a recipe for me  based on the amount of calories i ate daily is ${totalcalorie}.
    The recipe should only contain real, edible ingredients.
    Adhere to food safety and handling best practices like ensuring that poultry is fully cooked.
    Do not repeat any ingredients.
    Do not use symbols in the recipe.


    After providing the recipe, add an descriptions that creatively explains why the recipe is good based on today consumable calories.  Tell a short story of a travel experience that inspired the recipe.
    List out any ingredients that are potential allergens.
    Provide a summary of how many people the recipe will serve and the the nutritional information per serving.

    

    ''';

    final response = await _model.generateContent([Content.text(prompt)]);

    return '${response.text}';
  }
}

class GeminierrorException implements Exception {
  const GeminierrorException([this.message = 'Unkown problem']);

  final String message;

  @override
  String toString() => 'GeminierrorException: $message';
}
