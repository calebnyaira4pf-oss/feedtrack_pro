import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<_SettingItem> options = const [
    _SettingItem(
      title: 'Account',
      subtitle: 'Manage your account details',
      icon: Icons.person,
      detail:
          'Update your profile, change your password, and manage your saved account information.',
    ),
    _SettingItem(
      title: 'Notifications',
      subtitle: 'Notification preferences',
      icon: Icons.notifications,
      detail:
          'Choose which alerts you want to receive, including order updates and inventory alerts.',
    ),
    _SettingItem(
      title: 'Privacy',
      subtitle: 'Privacy and security settings',
      icon: Icons.lock,
      detail:
          'Update your privacy settings, app permissions, and control how your data is used.',
    ),
    _SettingItem(
      title: 'Help',
      subtitle: 'Support and feedback',
      icon: Icons.help,
      detail:
          'Access help articles, send feedback, and get support for using FeedTrack Pro.',
    ),
  ];

  int selectedIndex = 0;
  Map<String, String>? currentUser;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _selectOption(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService().getCurrentUser();
    if (!mounted) return;
    setState(() {
      currentUser = user?.map((key, value) => MapEntry(key, value.toString()));
      nameController.text = currentUser?['name'] ?? '';
      phoneController.text = currentUser?['phone'] ?? '';
      emailController.text = currentUser?['email'] ?? '';
    });
  }

  Future<void> _saveAccountUpdates() async {
    final email = currentUser?['email'];
    if (email == null) return;

    final updated = await AuthService().updateUser(
      email,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      password:
          passwordController.text.isEmpty ? null : passwordController.text,
    );

    if (!mounted) return;

    if (!updated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to update account details.')),
      );
      return;
    }

    await _loadCurrentUser();
    if (!mounted) return;

    passwordController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account details updated successfully.')),
    );
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 650;
          return isWide
              ? Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: _buildOptionList(context, isWide),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      flex: 5,
                      child: _buildDetailPane(options[selectedIndex]),
                    ),
                  ],
                )
              : _buildOptionList(context, isWide);
        },
      ),
    );
  }

  Widget _buildOptionList(BuildContext context, bool isWide) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        for (var i = 0; i < options.length; i++)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Icon(options[i].icon),
              title: Text(options[i].title),
              subtitle: Text(options[i].subtitle),
              trailing: const Icon(Icons.chevron_right),
              selected: isWide && selectedIndex == i,
              selectedTileColor: Colors.green.shade50,
              onTap: () {
                if (isWide) {
                  _selectOption(i);
                } else {
                  if (options[i].title == 'Account') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _AccountDetailScreen(
                          user: currentUser,
                          onSave: (name, phone, password) async {
                            nameController.text = name;
                            phoneController.text = phone;
                            passwordController.text = password;
                            await _saveAccountUpdates();
                          },
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _SettingDetailScreen(option: options[i]),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          subtitle: const Text('Sign out of your account'),
          onTap: _logout,
        ),
      ],
    );
  }

  Widget _buildDetailPane(_SettingItem option) {
    if (option.title == 'Account') {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: currentUser == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your account details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Leave blank to keep current password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveAccountUpdates,
                    child: const Text('Save Account Details'),
                  ),
                ],
              ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(option.icon, size: 28, color: Colors.green.shade700),
              const SizedBox(width: 12),
              Text(
                option.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            option.detail,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Settings details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildDetailPoint('Personalize your experience.'),
          _buildDetailPoint('Change preferences and update app controls.'),
          _buildDetailPoint('Keep your information secure and up to date.'),
        ],
      ),
    );
  }

  Widget _buildDetailPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.check_circle_outline, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String detail;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.detail,
  });
}

class _SettingDetailScreen extends StatelessWidget {
  const _SettingDetailScreen({required this.option});

  final _SettingItem option;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(option.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(option.icon, size: 28, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Text(
                  option.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              option.detail,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            _buildActionTile('Update settings', context),
            _buildActionTile('View help topics', context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Open "$title"')),
          );
        },
      ),
    );
  }
}

class _AccountDetailScreen extends StatefulWidget {
  const _AccountDetailScreen({required this.user, required this.onSave});

  final Map<String, String>? user;
  final Future<void> Function(String name, String phone, String password) onSave;

  @override
  State<_AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<_AccountDetailScreen> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?['name'] ?? '');
    phoneController = TextEditingController(text: widget.user?['phone'] ?? '');
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: TextEditingController(
                text: widget.user?['email'] ?? '',
              ),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                hintText: 'Leave blank to keep current password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await widget.onSave(
                  nameController.text.trim(),
                  phoneController.text.trim(),
                  passwordController.text,
                );
                if (!mounted) return;
                navigator.pop();
              },
              child: const Text('Save Account Details'),
            ),
          ],
        ),
      ),
    );
  }
}
