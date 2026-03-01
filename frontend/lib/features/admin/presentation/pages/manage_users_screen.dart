import 'package:flutter/material.dart';
import 'package:wasl/core/services/api_client.dart';
import 'user_details_screen.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'الكل';
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;
  String? _error;

  final List<String> _filters = [
    'الكل',
    'طلاب',
    'مقدمي خدمة',
    'نشط',
    'موقوف',
  ];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final json = await ApiClient.get('/api/admin/users');
      final List<dynamic> list = json['data'] as List<dynamic>;
      setState(() {
        _users = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading users: $e');
      setState(() {
        _error = 'حدث خطأ أثناء تحميل المستخدمين';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredUsers() {
    return _users.where((user) {
      final name = (user['name'] ?? '').toString().toLowerCase();
      final email = (user['email'] ?? '').toString().toLowerCase();
      final id = (user['id'] ?? '').toString();
      final search = _searchController.text.toLowerCase();

      final matchesSearch = name.contains(search) ||
          email.contains(search) ||
          id.contains(search);

      bool matchesFilter = true;
      if (_selectedFilter == 'طلاب') {
        matchesFilter = user['role'] == 'طالب';
      } else if (_selectedFilter == 'مقدمي خدمة') {
        matchesFilter = user['role'] == 'مقدم خدمة';
      } else if (_selectedFilter == 'نشط') {
        matchesFilter = user['status'] == 'نشط';
      } else if (_selectedFilter == 'موقوف') {
        matchesFilter = user['status'] == 'موقوف';
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredUsers = _getFilteredUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUsers,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'ابحث بالاسم، الإيميل، أو الـ ID...',
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    // Filters
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final filter = _filters[index];
                          final isSelected = filter == _selectedFilter;
                          return ChoiceChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedFilter = filter;
                                }
                              });
                            },
                            selectedColor: theme.primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey.shade700,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected ? theme.primaryColor : Colors.grey.shade300,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Users List
                    Expanded(
                      child: filteredUsers.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: _loadUsers,
                              child: ListView.separated(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
                                itemCount: filteredUsers.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final user = filteredUsers[index];
                                  return _buildUserCard(user, theme);
                                },
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد مستخدمون مطابقون لبحثك',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, ThemeData theme) {
    final isActive = user['status'] == 'نشط';
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          final updatedUser = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsScreen(user: Map.from(user)),
            ),
          );
          if (updatedUser != null && mounted) {
            _loadUsers();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                child: Text(
                  (user['name'] ?? '?').toString().isNotEmpty
                      ? user['name'].toString().substring(0, 1)
                      : '?',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'] ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withValues(alpha: 0.1)
                      : theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user['status'] ?? '',
                  style: TextStyle(
                    color: isActive ? Colors.green.shade700 : theme.colorScheme.error,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
