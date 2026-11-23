import 'package:flutter/material.dart';

class NoAccessScreen extends StatefulWidget {
  const NoAccessScreen({super.key});

  @override
  State<NoAccessScreen> createState() => _NoAccessScreenState();
}

class _NoAccessScreenState extends State<NoAccessScreen>
    with TickerProviderStateMixin {
  static const String fontFamily = 'AARTHA';

  static const Color background = Color(0xFF18372B);
  static const Color cardColor = Color(0xFF1F4435);
  static const Color borderColor = Color(0xFF34584A);
  static const Color gold = Color(0xFFC4A76C);
  static const Color cream = Color(0xFFF4F1E9);
  static const Color muted = Color(0xFFB5C3B9);
  static const Color danger = Color(0xFFFF8A80);

  late final AnimationController _entranceController;
  late final AnimationController _iconController;
  late final AnimationController _ringController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _iconScaleAnimation;
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

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.6,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 70,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 30),
    ]).animate(_iconController);

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _ringAnimation = CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeOut,
    );

    _entranceController.forward();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _iconController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _iconController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  Widget _animatedSection({required Widget child, required double delay}) {
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(delay, 1, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _accessIcon() {
    return AnimatedBuilder(
      animation: Listenable.merge([_iconController, _ringController]),
      builder: (context, child) {
        final ringProgress = _ringAnimation.value;

        return Transform.scale(
          scale: _iconScaleAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 88 + (ringProgress * 20),
                height: 88 + (ringProgress * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: gold.withValues(alpha: 0.6 * (1 - ringProgress)),
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cardColor,
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: const Center(
                  child: Icon(Icons.block_rounded, size: 40, color: danger),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _primaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          // Add your back navigation here later.
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: const Color(0xFF12241C),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Go back',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          // Add contact broker action here later.
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: cream,
          side: const BorderSide(color: borderColor, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Contact your broker',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                  child: Column(
                    children: [
                      _animatedSection(
                        delay: 0,
                        child: Center(
                          child: Image.asset(
                            'assets/aartha_logo.png',
                            width: 64,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      _animatedSection(delay: 0.12, child: _accessIcon()),

                      _animatedSection(
                        delay: 0.25,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                            "You don't have access",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: cream,
                            ),
                          ),
                        ),
                      ),

                      _animatedSection(
                        delay: 0.38,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 290),
                            child: const Text(
                              "Your account doesn't have permission "
                              "to view this page. If you think this is "
                              "a mistake, contact your broker.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: 14,
                                height: 1.5,
                                color: muted,
                              ),
                            ),
                          ),
                        ),
                      ),

                      _animatedSection(
                        delay: 0.52,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child: Column(
                            children: [
                              _primaryButton(),
                              const SizedBox(height: 12),
                              _secondaryButton(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
