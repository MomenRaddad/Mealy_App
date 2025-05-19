import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadJsonToFirestore() async {
  try {
    final String response = await rootBundle.loadString('assets/data/meals.json');
    final List<dynamic> data = json.decode(response);

    final mealsRef = FirebaseFirestore.instance.collection('mealsList');

    for (var meal in data) {
      await mealsRef.add(meal);
    }

    print("✅ All meals uploaded to Firestore in 'mealsList'");
  } catch (e) {
    print("❌ Error uploading JSON to Firestore: $e");
  }
}
