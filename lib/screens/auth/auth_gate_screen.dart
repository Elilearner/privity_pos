import 'package:flutter/material.dart';

import '../../services/service_locator.dart';
import '../home/home_screen.dart';
import 'initial_admin_setup_screen.dart';
import 'login_screen.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  bool _loading = true;

  bool _hasAdministrator = false;

  @override
  void initState() {
    super.initState();

    Services.auth.addListener(_handleAuthChanged);

    _checkAuthenticationState();
  }

  @override
  void dispose() {
    Services.auth.removeListener(_handleAuthChanged);

    super.dispose();
  }

  void _handleAuthChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> _checkAuthenticationState() async {
    final hasAdministrator = await Services.auth.hasAdministrator();

    if (!mounted) {
      return;
    }

    setState(() {
      _hasAdministrator = hasAdministrator;
      _loading = false;
    });
  }

  Future<void> _administratorCreated() async {
    final hasAdministrator = await Services.auth.hasAdministrator();

    if (!mounted) {
      return;
    }

    setState(() {
      _hasAdministrator = hasAdministrator;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (Services.auth.isAuthenticated) {
      return const HomeScreen();
    }

    if (!_hasAdministrator) {
      return InitialAdminSetupScreen(
        onAdministratorCreated: _administratorCreated,
      );
    }

    return const LoginScreen();
  }
}
