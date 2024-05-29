import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class Geminifunction {
  Geminifunction()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: 'AIzaSyAsKT6BMedNILln1Jb7NerLcGeqESvfW1k',
        );

  final GenerativeModel _model;

  Future<String> Caloriesvalue(String name) async {
    String? calories;
    try {
      final calories = await FoodCalories(name);
      if (calories == null) {
        print('error');
      }
      if (jsonDecode(calories!) case {'Calories': String items}) {
        return items;
      }
      throw const GeminierrorException('Invalid JSON schema');
    } on GenerativeAIException {
      throw const GeminierrorException(
        'Problem with the Generative AI service',
      );
    } catch (e) {
      if (e is GeminierrorException) rethrow;

      print(calories);
      print(e);
      return '200';
      // throw const GeminierrorException();
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
        'You are a calories finder where you find the calories of food by just name.'
        'You have given the $name find the calories.'
        //'You have too give only the average one value'
        //'Your value must be constant'
        'You doesnt find the calories give your response as error'
        'Provide your response as a JSON object with the following schema: {"Calories": ""}';
    'Do not return your result as Markdown.';

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
}

class GeminierrorException implements Exception {
  const GeminierrorException([this.message = 'Unkown problem']);

  final String message;

  @override
  String toString() => 'GeminierrorException: $message';
}

/*

Future<Uint8List> takePhoto() async {
    try {
      final photo = await imagePicker.pickImage(source: ImageSource.camera);

      if (photo == null) throw const PhotoPickerException();

      final bytes = await photo.readAsBytes();

      return bytes;
    } on Exception {
      throw const PhotoPickerException();
    }
  }

*/