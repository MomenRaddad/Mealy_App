import 'package:flutter/material.dart';
import 'package:meal_app/models/user_model.dart';
import 'package:meal_app/view/screens/Login_Signup/Signup/signup.dart';
import 'package:meal_app/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class FullUserTable extends StatefulWidget {
  const FullUserTable({super.key});

  @override
  State<FullUserTable> createState() => _FullUserTableState();
}

class _FullUserTableState extends State<FullUserTable> {
  int rowsPerPage = 5;
  int currentPage = 0;

  late UserViewModel vm;
  String _statusFilter = 'All';

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
          final filtered = vm.filteredUsers.where((u) {
            switch (_statusFilter) {
              case 'Active':
                return u.accountStatus == AccountStatus.active;
              case 'Inactive':
                return u.accountStatus == AccountStatus.inactive;
              case 'Admins':
                return u.isPrivileged;
              default:
                return true;
            }
          }).toList();

          final totalUsers = filtered.length;
          final paginatedUsers = filtered
              .skip(currentPage * rowsPerPage)
              .take(rowsPerPage)
              .toList();

          return Scaffold(
            appBar: AppBar(title: const Text('All Users')),
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
                          // Top Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: _statusFilter,
                                items: ['All', 'Active', 'Inactive', 'Admins']
                                    .map((e) =>
                                        DropdownMenuItem(value: e, child: Text(e)))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _statusFilter = value!;
                                    currentPage = 0;
                                  });
                                },
                              ),
                              PopupMenuButton<UserSortOption>(
                                initialValue: vm.sortOption,
                                onSelected: (val) {
                                  vm.updateSortOption(val);
                                  setState(() {
                                    currentPage = 0;
                                  });
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: UserSortOption.nameAZ,
                                    child: Text("Name A → Z"),
                                  ),
                                  PopupMenuItem(
                                    value: UserSortOption.nameZA,
                                    child: Text("Name Z → A"),
                                  ),
                                  PopupMenuItem(
                                    value: UserSortOption.newest,
                                    child: Text("Newest First"),
                                  ),
                                  PopupMenuItem(
                                    value: UserSortOption.oldest,
                                    child: Text("Oldest First"),
                                  ),
                                ],
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.sort, color: Colors.black),
                                  label: const Text("Sort By",
                                      style: TextStyle(color: Colors.black)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                  onPressed: null,
                                ),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.person_add_alt_1),
                                label: const Text("Create Admin"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignUpScreen(showAdminOption: true),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Search Field
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search by name or email...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: vm.updateSearchQuery,
                          ),
                          const SizedBox(height: 16),

                          // Table
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Role')),
                                DataColumn(label: Text('Created')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: paginatedUsers.map((user) {
                                return DataRow(cells: [
                                  DataCell(Text(user.userName, style: const TextStyle(color: Colors.black))),
                                  DataCell(Text(user.userEmail, style: const TextStyle(color: Colors.black))),
                                  DataCell(
                                    Text(
                                      user.accountStatus.name,
                                      style: TextStyle(
                                        color: user.accountStatus == AccountStatus.inactive
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(user.isPrivileged ? 'Admin' : 'User', style: const TextStyle(color: Colors.black))),
                                  DataCell(Text(user.createdAt.toLocal().toString().split(' ').first, style: const TextStyle(color: Colors.black))),
                                  DataCell(Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        tooltip: 'Edit User',
                                        onPressed: () => _showEditDialog(context, user),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          user.accountStatus == AccountStatus.active
                                              ? Icons.person_off
                                              : Icons.person,
                                        ),
                                        tooltip: 'Toggle Status',
                                        onPressed: () => vm.toggleUserStatus(user.userId),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        tooltip: 'Delete User',
                                        onPressed: () => _confirmDelete(context, user.userId),
                                      ),
                                    ],
                                  )),
                                ]);
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Footer: Pagination
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Showing ${paginatedUsers.length} of $totalUsers'),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios),
                                    onPressed: currentPage > 0
                                        ? () => setState(() => currentPage--)
                                        : null,
                                  ),
                                  Text('Page ${currentPage + 1}'),
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    onPressed:
                                        (currentPage + 1) * rowsPerPage < totalUsers
                                            ? () => setState(() => currentPage++)
                                            : null,
                                  ),
                                ],
                              )
                            ],
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
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
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
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                final updated = user.copyWith(
                  userName: nameController.text.trim(),
                  userEmail: emailController.text.trim(),
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
