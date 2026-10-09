import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import 'auth/auth_controller.dart';
import 'auth/auth_repository.dart';
import 'auth/session_store.dart';
import 'screens/auth_gate.dart';
import 'theme/aartha_theme.dart';

void main() => runApp(const AarthaApp());

class AarthaApp extends StatefulWidget {
  const AarthaApp({super.key});

  @override
  State<AarthaApp> createState() => _AarthaAppState();
}

class _AarthaAppState extends State<AarthaApp> {
  late final AuthController _auth = AuthController(
    repository: HttpAuthRepository(),
    store: SecureSessionStore(),
  )..restore();

  @override
  void dispose() {
    _auth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AARTHA',
      debugShowCheckedModeBanner: false,
      theme: AarthaTheme.dark,
      themeMode: ThemeMode.dark,
      // Mouse / trackpad drag-scrolling on desktop and web, like touch.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      home: AuthGate(controller: _auth),
    );
  }
}
