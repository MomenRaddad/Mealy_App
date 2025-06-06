import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadJsonToFirestore() async {
  try {
    final jsonString = await rootBundle.loadString('assets/data/meals.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    for (final meal in jsonList) {
      await FirebaseFirestore.instance.collection('mealsList').add(meal);
    }

    print("✅ Meals uploaded successfully!");
  } catch (e) {
    print("❌ Error uploading meals: $e");
  }
}
