import 'package:flutter/material.dart';

class SessionExpiredScreen extends StatefulWidget {
  const SessionExpiredScreen({super.key});

  @override
  State<SessionExpiredScreen> createState() => _SessionExpiredScreenState();
}

class _SessionExpiredScreenState extends State<SessionExpiredScreen>
    with TickerProviderStateMixin {
  static const String fontFamily = 'AARTHA';

  static const Color backgroundColor = Color(0xFF18372B);
  static const Color cardColor = Color(0xFF1F4435);
  static const Color borderColor = Color(0xFF34584A);
  static const Color goldColor = Color(0xFFC4A76C);
  static const Color creamColor = Color(0xFFF4F1E9);
  static const Color mutedColor = Color(0xFFB5C3B9);

  late final AnimationController _entranceController;
  late final AnimationController _iconController;
  late final AnimationController _ringController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _iconAnimation;
  late final Animation<double> _ringAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _iconAnimation = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _ringAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _ringController, curve: Curves.easeOut));

    _entranceController.forward();
    _iconController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _iconController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        _buildLogo(),
                        const SizedBox(height: 48),
                        _buildExpiredContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/aartha_logo.png',
        width: 64,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildExpiredContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLockIcon(),
        const SizedBox(height: 24),

        const Text(
          'Session expired',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: creamColor,
            height: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'For your security, please sign in again.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            height: 1.5,
            color: mutedColor,
          ),
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              // UI only: connect sign-in navigation later.
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: goldColor,
              foregroundColor: const Color(0xFF12241C),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Sign in',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockIcon() {
    return ScaleTransition(
      scale: _iconAnimation,
      child: AnimatedBuilder(
        animation: _ringAnimation,
        builder: (context, child) {
          final progress = _ringAnimation.value / 10;
          final opacity = (1 - progress).clamp(0.0, 1.0);

          return Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cardColor,
              border: Border.all(color: borderColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: goldColor.withValues(alpha: opacity * 0.6),
                  spreadRadius: _ringAnimation.value,
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.lock_outline_rounded,
                color: goldColor,
                size: 40,
              ),
            ),
          );
        },
      ),
    );
  }
}
