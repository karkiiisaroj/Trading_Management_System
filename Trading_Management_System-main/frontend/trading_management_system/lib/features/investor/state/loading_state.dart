import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({super.key, this.onDestinationSelected});

  final ValueChanged<int>? onDestinationSelected;

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState>
    with SingleTickerProviderStateMixin {

  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    _shimmerAnimation = Tween<double>(begin: 0.35, end: 1).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Widget _skeleton({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Opacity(opacity: _shimmerAnimation.value, child: child);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _holdingSkeleton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeleton(width: 70, height: 14, radius: 8),
              const SizedBox(height: 8),
              _skeleton(width: 130, height: 11),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _skeleton(width: 80, height: 14, radius: 8),
              const SizedBox(height: 8),
              _skeleton(width: 60, height: 11),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summarySkeleton() {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeleton(width: 90, height: 12),
              const SizedBox(height: 10),
              _skeleton(width: 140, height: 22, radius: 8),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _skeleton(width: 50, height: 12),
              const SizedBox(height: 10),
              _skeleton(width: 70, height: 18, radius: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationItem({
    required IconData icon,
    required String label,
    required int index,
    bool selected = false,
  }) {
    final color = selected ? AppColors.brass : AppColors.muted;

    return Expanded(
      child: InkWell(
        onTap: () => widget.onDestinationSelected?.call(index),
        child: SizedBox(
          height: 76,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigation() {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _bottomNavigationItem(
            icon: Icons.home_outlined,
            label: 'Home',
            index: 0,
          ),
          _bottomNavigationItem(
            icon: Icons.pie_chart_outline,
            label: 'Portfolio',
            index: 1,
            selected: true,
          ),
          _bottomNavigationItem(
            icon: Icons.show_chart,
            label: 'Market',
            index: 2,
          ),
          _bottomNavigationItem(
            icon: Icons.swap_vert,
            label: 'Trade',
            index: 3,
          ),
          _bottomNavigationItem(
            icon: Icons.more_horiz,
            label: 'More',
            index: 4,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Portfolio',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Loading your holdings',
                      style: TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                    _summarySkeleton(),
                    const SizedBox(height: 22),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        'Loading your holdings…',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ),
                    _holdingSkeleton(),
                    _holdingSkeleton(),
                    _holdingSkeleton(),
                    _holdingSkeleton(),
                    _holdingSkeleton(),
                  ],
                ),
              ),
            ),
            _bottomNavigation(),
          ],
        ),
      ),
    );
  }
}
