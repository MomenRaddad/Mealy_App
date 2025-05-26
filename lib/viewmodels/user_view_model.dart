import 'package:flutter/material.dart';
import 'package:meal_app/models/user_model.dart';
import 'package:meal_app/services/user_service.dart';

enum UserSortOption {
  nameAZ,
  nameZA,
  newest,
  oldest,
}

class UserViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  List<UserModel> _users = [];
  String _searchQuery = '';
  Map<String, int> _stats = {};
  Map<String, int> _logins = {};
  bool _loading = false;

  List<UserModel> get users => _users;
  Map<String, int> get stats => _stats;
  Map<String, int> get logins => _logins;
  bool get isLoading => _loading;

  UserSortOption _sortOption = UserSortOption.newest;
  UserSortOption get sortOption => _sortOption;
  UserService get userService => _userService;

  void updateSortOption(UserSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  List<UserModel> get filteredUsers {
    List<UserModel> filtered = _searchQuery.isEmpty
        ? _users
        : _users.where((user) {
            final name = user.userName.toLowerCase();
            final email = user.userEmail.toLowerCase();
            return name.contains(_searchQuery.toLowerCase()) ||
                email.contains(_searchQuery.toLowerCase());
          }).toList();

    switch (_sortOption) {
      case UserSortOption.nameAZ:
        filtered.sort((a, b) => a.userName.compareTo(b.userName));
        break;
      case UserSortOption.nameZA:
        filtered.sort((a, b) => b.userName.compareTo(a.userName));
        break;
      case UserSortOption.oldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case UserSortOption.newest:
      default:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return filtered;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchAllData() async {
    _loading = true;
    notifyListeners();
    _users = await _userService.fetchAllUsers();
    _stats = await _userService.fetchUserStats();
    _logins = await _userService.fetchDailyLogins();
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteUser(String userId) async {
    await _userService.deleteUser(userId);
    await fetchAllData();
  }

  Future<void> toggleUserStatus(String userId) async {
    final index = _users.indexWhere((u) => u.userId == userId);
    if (index == -1) return;

    final user = _users[index];
    final newStatus = user.accountStatus == AccountStatus.active
        ? AccountStatus.inactive
        : AccountStatus.active;

    final updated = user.copyWith(accountStatus: newStatus);
    await _userService.updateUser(updated);
    await fetchAllData();
  }
}
