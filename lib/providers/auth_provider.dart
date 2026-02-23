import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uho/core/auth.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? user;
  Map<String, dynamic>? profile;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    user = _authService.currentUser;
    if (user != null) {
      await _loadProfile();
    }

    _authService.authState.listen((data) async {
      user = data.session?.user;
      if (user != null) {
        await _loadProfile();
      } else {
        profile = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadProfile() async {
    final existing = await Supabase.instance.client
      .from('profiles')
      .select()
      .eq('user_id', user!.id)
      .maybeSingle();

    if (existing != null) {
      profile = existing;
      return;
    }

    await Supabase.instance.client.from('profiles').insert({
      'user_id': user!.id,
      'username': user!.email?.split('@').first ?? 'user',
      'ratings_count': 0,
      'description': '',
    });

    profile = await Supabase.instance.client
      .from('profiles')
      .select()
      .eq('user_id', user!.id)
      .single();
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email: email, password: password);
  }

  Future<void> signUp(String email, String password, String username) async {
    await _authService.signUp(
      email: email,
      password: password,
      username: username,
    );
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  bool get isLoggedIn => user != null;
  String get username => profile?['username'] ?? '';
}