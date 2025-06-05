import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:meal_app/core/colors.dart';
import 'package:meal_app/models/dashboard_card_data.dart';
import 'package:meal_app/models/user_model.dart';
import 'package:meal_app/utils/navigation_utils.dart';
import 'package:meal_app/view/screens/Login_Signup/Signup/signup.dart';
import 'package:meal_app/view/screens/admin_screens/admin_home/dashboard_section.dart';
import 'package:meal_app/view/screens/admin_screens/user_management/full_user_table.dart';
import 'package:meal_app/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late UserViewModel vm;
  final String _statusFilter = 'All';

  @override
  void initState() {
    super.initState();
    vm = UserViewModel();
    vm.fetchAllData();
  }

  @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider<UserViewModel>.value(
        value: vm,
        child: Consumer<UserViewModel>(
          builder: (context, vm, _) {
            final stats = vm.stats;
            final logins = vm.logins;

            final fullLogins = {
              'Mon': 0, 'Tue': 0, 'Wed': 0, 'Thu': 0, 'Fri': 0, 'Sat': 0, 'Sun': 0,
            }..addAll(logins);

            final loginValues = fullLogins.values.toList();
            final maxLogin = (loginValues.isEmpty ? 1 : loginValues.reduce((a, b) => a > b ? a : b)) + 1;

            return Scaffold(
              //appBar: AppBar(title: const Text('Users Management')),
              body: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => vm.fetchAllData(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Users Management',
                              style:
                              Theme.of(context).textTheme.headlineLarge
                              ),                               
                            const SizedBox(height: 16),

                            // Stats Row
                            DashboardSection(
                              cards: [
                                DashboardCardData(
                                  label: 'Active',
                                  count: vm.stats['active']?.toString() ?? '0',
                                  color: AppColors.primary,
                                  icon: Icons.person,
                                ),
                                DashboardCardData(
                                  label: 'Inactive',
                                  count: vm.stats['inactive']?.toString() ?? '0',
                                  color: AppColors.accent1,
                                  icon: Icons.person_off,
                                ),
                                DashboardCardData(
                                  label: 'Total',
                                  count: vm.stats['total']?.toString() ?? '0',
                                  color: AppColors.accent2,
                                  icon: Icons.groups,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),
                            Text(
                              "Daily App Logins",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),                            
                            const SizedBox(height: 16),

                            // Bar Chart
                            SizedBox(
                              height: 240,
                              child: BarChart(
                                BarChartData(
                                  maxY: maxLogin.toDouble(),
                                  gridData: FlGridData(show: true, drawHorizontalLine: true, horizontalInterval: 1),
                                  borderData: FlBorderData(show: false),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, _) {
                                          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                          final dayLabel = days[value.toInt() % 7];

                                          final today = DateTime.now().weekday; // 1 = Mon, ..., 7 = Sun
                                          final currentDayIndex = today - 1; // Convert to 0-based

                                          final isToday = value.toInt() == currentDayIndex;

                                          return Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              dayLabel,
                                              style: TextStyle(
                                                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                                color: isToday ? AppColors.textPrimary: AppColors.textSecondary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        }
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 1,
                                        getTitlesWidget: (value, _) =>
                                            Text(value.toInt().toString()),
                                      ),
                                    ),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  ),
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: AppColors.accent1,
                                      getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                                        '${rod.toY.toInt()}',
                                        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  barGroups: List.generate(7, (index) {
                                    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                    final count = fullLogins[days[index]] ?? 0;
                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: count.toDouble(),
                                          color: AppColors.accent1,
                                          width: 35,
                                          borderRadius: BorderRadius.circular(4),
                                          backDrawRodData: BackgroundBarChartRodData(
                                            show: true,
                                            toY: maxLogin.toDouble(),
                                            color: AppColors.accent1.withValues(alpha: 170),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),
                            Row(
                              children: [
                                Text(
                                  "Recent Users",
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("View All Users"),
                                  onPressed: () {
                                    AppNavigator.pushWithoutNavBar(context, FullUserTable());
                                  },
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Mini Table
                            Column(
                              children: vm.filteredUsers.take(4).map((user) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  child: ListTile(
                                    leading: const Icon(Icons.person),
                                    title: Text(user.userName),
                                    subtitle: Text(user.userEmail),
                                    trailing: Text(
                                      user.isPrivileged ? 'Admin' : 'User',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: user.isPrivileged ? FontWeight.bold : FontWeight.normal,
                                        color: user.isPrivileged ? AppColors.primary : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        ),
      );
    }


  void _confirmDelete(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                vm.deleteUser(userId);
              },
              child: const Text("Delete")),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.userName);
    final emailController = TextEditingController(text: user.userEmail);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                final updated = UserModel(
                  userId: user.userId,
                  userName: nameController.text.trim(),
                  userEmail: emailController.text.trim(),
                  accountStatus: user.accountStatus,
                  isPrivileged: user.isPrivileged,
                  createdAt: user.createdAt,
                  phoneNumber: user.phoneNumber,
                  gender: user.gender,
                  DOB: user.DOB,
                );
                vm.userService.updateUser(updated);
                vm.fetchAllData();
                Navigator.of(ctx).pop();
              },
              child: const Text("Save")),
        ],
      ),
    );
  }
}



class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.black),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
            const SizedBox(height: 6),
            Text(count.toString(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
