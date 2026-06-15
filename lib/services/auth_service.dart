import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _emailKey = 'email';

  Future<Map<String, dynamic>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null || usersJson.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(usersJson);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {};
  }

  Future<void> _saveUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    final users = await _loadUsers();

    if (users.containsKey(email)) {
      return false;
    }

    users[email] = {
      'name': name,
      'phone': phone,
      'password': password,
    };

    await _saveUsers(users);
    return true;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);

    if (email == null) return null;

    final users = await _loadUsers();
    final user = users[email];

    if (user is Map<String, dynamic>) {
      return {
        'email': email,
        'name': user['name'] as String? ?? '',
        'phone': user['phone'] as String? ?? '',
      };
    }

    return null;
  }

  Future<bool> updateUser(
    String email, {
    String? name,
    String? phone,
    String? password,
  }) async {
    final users = await _loadUsers();
    final user = users[email];

    if (user is! Map<String, dynamic>) {
      return false;
    }

    final updated = Map<String, dynamic>.from(user);
    if (name != null) updated['name'] = name;
    if (phone != null) updated['phone'] = phone;
    if (password != null) updated['password'] = password;

    users[email] = updated;
    await _saveUsers(users);
    return true;
  }

  Future<bool> login(String email, String password) async {
    final users = await _loadUsers();
    final user = users[email];

    if (user is Map<String, dynamic> && user['password'] == password) {
      await saveLogin(email);
      return true;
    }

    return false;
  }

  Future<bool> isEmailRegistered(String email) async {
    final users = await _loadUsers();
    return users.containsKey(email);
  }

  Future<void> saveLogin(String email) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_emailKey, email);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_emailKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_emailKey);
  }
}