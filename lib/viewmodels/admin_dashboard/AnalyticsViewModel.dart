import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AnalyticsViewModel extends ChangeNotifier {
  List<double> visitsPerDay = [];
  bool isLoading = true;

  StreamSubscription? _subscription;

  void loadWeeklyVisits() {
    isLoading = true;
    notifyListeners();

    _subscription = FirebaseFirestore.instance
        .collection('daily_visits')
        .snapshots()
        .listen((querySnapshot) {
          final now = DateTime.now();
          final formatter = DateFormat('yyyy-M-d');

          final List<DateTime> weekDays = List.generate(
            7,
            (i) => now.subtract(Duration(days: now.weekday - 1 - i)),
          );

          final List<String> weekDocIds =
              weekDays.map((d) => formatter.format(d)).toList();

          final Map<String, double> tempMap = {};

          for (final doc in querySnapshot.docs) {
            final docId = doc.id;
            if (weekDocIds.contains(docId)) {
              final count = (doc['visits'] ?? 0).toDouble();
              tempMap[docId] = count;
            }
          }

          visitsPerDay = weekDocIds.map((id) => tempMap[id] ?? 0).toList();

          isLoading = false;
          notifyListeners();
        });
  }
}
