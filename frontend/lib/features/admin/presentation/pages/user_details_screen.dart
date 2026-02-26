import 'package:flutter/material.dart';
import '../widgets/suspend_action_dialog.dart';

class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  
  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _status = widget.user['status'];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showActionDialog() {
    final bool isActive = _status == 'نشط';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SuspendActionDialog(
          isActive: isActive,
          userName: widget.user['name'],
          onSubmit: (reason) {
            // Simulated delay for saving status
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isActive
                            ? 'تم إيقاف الحساب بنجاح. السبب: $reason'
                            : 'تم إعادة تفعيل الحساب بنجاح.',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).primaryColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
            
            setState(() {
              _status = isActive ? 'موقوف' : 'نشط';
              // Update user object as well for when returning to list
              widget.user['status'] = _status;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = _status == 'نشط';

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المستخدم'),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, widget.user),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24.0),
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                  child: Text(
                    widget.user['name'].substring(0, 1),
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.user['name'],
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: ${widget.user['id']} | ${widget.user['role']}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withValues(alpha: 0.1)
                        : theme.colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _status,
                    style: TextStyle(
                      color: isActive ? Colors.green.shade700 : theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: theme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: theme.primaryColor,
              tabs: const [
                Tab(text: 'البيانات الأساسية'),
                Tab(text: 'سجل النشاط'),
              ],
            ),
          ),
          
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBasicInfoTab(theme),
                _buildActivityLogTab(theme),
              ],
            ),
          ),
        ],
      ),
      
      // Sticky Action Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _showActionDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? theme.colorScheme.error : theme.primaryColor,
            ),
            child: Text(
              isActive ? 'إيقاف الحساب' : 'إعادة تفعيل الحساب',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
        children: [
        _buildInfoRow('البريد الإلكتروني', widget.user['email']),
        const Divider(height: 32),
        _buildInfoRow('رقم الهاتف', '+966 50 123 4567'),
        const Divider(height: 32),
        _buildInfoRow('تاريخ الانضمام', '12 اكتوبر 2023'),
        const Divider(height: 32),
        _buildInfoRow('الجامعة', 'جامعة الملك سعود'),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLogTab(ThemeData theme) {
    // Dummy Activity Log
    final List<Map<String, dynamic>> activities = [
      {
        'title': 'إلغاء حجز',
        'desc': 'المستخدم قام بإلغاء حجز مسار 201',
        'date': 'اليوم 10:30 ص',
        'isBad': true,
      },
      {
        'title': 'دفع رسوم',
        'desc': 'تم دفع رسوم اشتراك الشهر',
        'date': 'أمس 08:15 م',
        'isBad': false,
      },
      {
        'title': 'إنشاء حساب',
        'desc': 'تم إنشاء الحساب وتوثيقه',
        'date': '12 اكتوير 2023',
        'isBad': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: activity['isBad'] ? theme.colorScheme.error : theme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (index != activities.length - 1)
                    Container(
                      width: 2,
                      height: 50,
                      color: Colors.grey.shade300,
                      margin: const EdgeInsets.only(top: 4),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity['desc'],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activity['date'],
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
