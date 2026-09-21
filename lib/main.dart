import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/services/supabase_service.dart';
import 'screens/admin/admin_reset_password_screen.dart';
import 'screens/home/home_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey =
    GlobalKey<NavigatorState>();

StreamSubscription<AuthState>? _authSubscription;
StreamSubscription<Uri>? _linkSubscription;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  if (supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );

    _authSubscription =
        SupabaseService.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        _openResetScreen();
      }
    });

    final appLinks = AppLinks();

    _linkSubscription = appLinks.uriLinkStream.listen((uri) {
      if (uri.scheme == 'io.bookstore.app' &&
          uri.host == 'reset-password') {
        _openResetScreen();
      }
    });
  }

  runApp(const BookStoreApp());
}

void _openResetScreen() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;

    navigator.push(
      MaterialPageRoute(
        builder: (_) => const AdminResetPasswordScreen(),
      ),
    );
  });
}

class BookStoreApp extends StatelessWidget {
  const BookStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Book Haven',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5F0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B3A29),
        ),
        fontFamily: 'Arial',
      ),
      home: const HomeScreen(),
    );
  }
}
