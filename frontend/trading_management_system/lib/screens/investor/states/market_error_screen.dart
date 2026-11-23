import 'package:flutter/material.dart';

class MarketErrorScreen extends StatefulWidget {
  const MarketErrorScreen({super.key});

  @override
  State<MarketErrorScreen> createState() => _MarketErrorScreenState();
}

class _MarketErrorScreenState extends State<MarketErrorScreen>
    with TickerProviderStateMixin {
  static const String fontFamily = 'AARTHA';

  static const Color background = Color(0xFF18372B);
  static const Color sidebarColor = Color(0xFF12291F);
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

    _entranceController.forward();

    Future.delayed(const Duration(milliseconds: 150), () {
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

  Widget _animatedItem({required Widget child, required double start}) {
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, 1, curve: Curves.easeOutCubic),
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

  Widget _buildErrorIcon() {
    return AnimatedBuilder(
      animation: Listenable.merge([_iconController, _ringController]),
      builder: (context, child) {
        final ringProgress = Curves.easeOut.transform(_ringController.value);

        return Transform.scale(
          scale: _iconScaleAnimation.value,
          child: SizedBox(
            width: 108,
            height: 108,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 88 + ringProgress * 20,
                  height: 88 + ringProgress * 20,
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
                    color: cardColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 40,
                    color: danger,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          // Add market data retry logic later.
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
          'Try again',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
      _BottomNavItem('Home', Icons.home_outlined),
      _BottomNavItem('Portfolio', Icons.pie_chart_outline),
      _BottomNavItem('Market', Icons.trending_up),
      _BottomNavItem('Trade', Icons.swap_vert),
      _BottomNavItem('More', Icons.more_horiz),
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: sidebarColor,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: items.map((item) {
          final isActive = item.label == 'Market';

          return Expanded(
            child: InkWell(
              onTap: () {
                // UI-only navigation placeholder.
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, size: 22, color: isActive ? gold : muted),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isActive ? gold : muted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _animatedItem(
                              start: 0,
                              child: const Text(
                                'Market',
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                  color: cream,
                                ),
                              ),
                            ),

                            const SizedBox(height: 120),

                            Center(
                              child: Column(
                                children: [
                                  _animatedItem(
                                    start: 0.15,
                                    child: _buildErrorIcon(),
                                  ),

                                  _animatedItem(
                                    start: 0.3,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 24),
                                      child: Text(
                                        "Couldn't load market data",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: cream,
                                        ),
                                      ),
                                    ),
                                  ),

                                  _animatedItem(
                                    start: 0.45,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: SizedBox(
                                        width: 290,
                                        child: Text(
                                          'Check your connection and try again. '
                                          'If this keeps happening, contact '
                                          'your broker.',
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

                                  _animatedItem(
                                    start: 0.6,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 28),
                                      child: _buildRetryButton(),
                                    ),
                                  ),
                                ],
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

            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final String label;
  final IconData icon;

  const _BottomNavItem(this.label, this.icon);
}
