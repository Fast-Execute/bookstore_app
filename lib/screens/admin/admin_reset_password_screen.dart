import 'package:flutter/material.dart';

import '../../data/services/auth_service.dart';

class AdminResetPasswordScreen extends StatefulWidget {
  const AdminResetPasswordScreen({super.key});

  @override
  State<AdminResetPasswordScreen> createState() =>
      _AdminResetPasswordScreenState();
}

class _AdminResetPasswordScreenState
    extends State<AdminResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _loading = false;
  bool _obscure = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.length < 8) {
      _show('Password must be at least 8 characters.');
      return;
    }

    if (password != confirm) {
      _show('The passwords do not match.');
      return;
    }

    setState(() => _loading = true);

    try {
      await AuthService.updatePassword(password);
      if (!mounted) return;

      _show('Password updated. You can now sign in.');
      await Future<void>.delayed(const Duration(milliseconds: 700));

      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (_) {
      if (mounted) {
        _show('Unable to update password. Please request a new reset link.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      appBar: AppBar(
        title: const Text(
          'Reset Admin Password',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF7F5F0),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.lock_reset_rounded,
                      size: 72,
                      color: Color(0xFF5B3A29),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Create a new password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D211B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose a new password for your BOOK HAVEN administrator account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 28),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscure,
                      enabled: !_loading,
                      decoration: InputDecoration(
                        labelText: 'New password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: _loading
                              ? null
                              : () => setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmController,
                      obscureText: _obscureConfirm,
                      enabled: !_loading,
                      onSubmitted: (_) => _savePassword(),
                      decoration: InputDecoration(
                        labelText: 'Confirm new password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: _loading
                              ? null
                              : () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: FilledButton.icon(
                        onPressed: _loading ? null : _savePassword,
                        icon: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check_circle_outline),
                        label: Text(
                          _loading ? 'Updating...' : 'Set New Password',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
