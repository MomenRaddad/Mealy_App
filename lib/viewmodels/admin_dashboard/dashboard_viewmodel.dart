import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardViewModel extends ChangeNotifier {
  int usersCount = 0;
  int adminsCount = 0;
  int mealsCount = 0;
  bool isLoading = true;

  StreamSubscription? _userSub;
  StreamSubscription? _adminSub;
  StreamSubscription? _mealSub;

  void loadDashboardData() {
    isLoading = true;
    notifyListeners();

    _userSub = FirebaseFirestore.instance
        .collection('users')
        .where('isPrivileged', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
          usersCount = snapshot.docs.length;
          notifyListeners();
        });

    _adminSub = FirebaseFirestore.instance
        .collection('users')
        .where('isPrivileged', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
          adminsCount = snapshot.docs.length;
          notifyListeners();
        });

    _mealSub = FirebaseFirestore.instance
        .collection('meals')
        .snapshots()
        .listen((snapshot) {
          mealsCount = snapshot.docs.length;
          isLoading = false;
          notifyListeners();
        });
  }
}
