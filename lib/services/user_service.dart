import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserService {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<List<UserModel>> fetchAllUsers() async {
    final snapshot = await _users.orderBy('createdAt', descending: true).get();
    return snapshot.docs
        .map((doc) => UserModel.fromJson({
              ...doc.data(),
              'userId': doc.id,
            }))
        .toList();
  }

  Future<void> addUser(UserModel user) async {
    await _users.doc(user.userId).set(user.toJson());
  }

  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.userId).update(user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await _users.doc(userId).delete();
  }

  Future<Map<String, int>> fetchUserStats() async {
    final snapshot = await _users.get();
    int total = snapshot.size;
    int active = snapshot.docs.where((doc) => doc['accountStatus'] == 'active').length;
    int inactive = snapshot.docs.where((doc) => doc['accountStatus'] == 'inactive').length;

    return {
      'total': total,
      'active': active,
      'inactive': inactive,
    };
  }

  Future<Map<String, int>> fetchDailyLogins() async {
    final snapshot = await FirebaseFirestore.instance.collection('daily_logins').get();

    final Map<String, int> loginCounts = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };

    for (final doc in snapshot.docs) {
      try {
        final docId = doc.id; // e.g. '2025-5-22'
        final parts = docId.split('-');
        if (parts.length == 3) {
          final date = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
          final uids = List<String>.from(doc['uids'] ?? []);
          loginCounts[weekday] = loginCounts[weekday]! + uids.length;
        }
      } catch (e) {
        debugPrint("🛑 Error parsing login document '${doc.id}': $e");
      }
    }

    return loginCounts;
  }


  String _weekdayShort(int day) {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day % 7];
  }
}
