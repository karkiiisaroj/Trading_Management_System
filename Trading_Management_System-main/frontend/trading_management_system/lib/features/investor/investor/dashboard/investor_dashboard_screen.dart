import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class InvestorDashboardScreen extends StatefulWidget {
  const InvestorDashboardScreen({
    super.key,
    this.investorName = 'Investor',
    this.portfolioValue = 1245000,
    this.dailyGain = 12400,
    this.dailyGainPercent = 1.0,
    this.holdingsCount = 8,
    this.investedAmount = 1180000,
    this.onDestinationSelected,
    this.onExploreSelected,
  });

  final String investorName;
  final double portfolioValue;
  final double dailyGain;
  final double dailyGainPercent;
  final int holdingsCount;
  final double investedAmount;

  final ValueChanged<int>? onDestinationSelected;
  final ValueChanged<String>? onExploreSelected;

  @override
  State<InvestorDashboardScreen> createState() =>
      _InvestorDashboardScreenState();
}

class _InvestorDashboardScreenState extends State<InvestorDashboardScreen> {
  int selectedIndex = 0;


  String get greeting {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String formatNumber(double value) {
    final number = value.round().toString();
    final result = StringBuffer();

    for (int i = 0; i < number.length; i++) {
      if (i > 0 && (number.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(number[i]);
    }

    return result.toString();
  }

  String formatCompact(double value) {
    if (value >= 1000000) {
      return 'Rs. ${(value / 1000000).toStringAsFixed(2)}M';
    }

    if (value >= 1000) {
      return 'Rs. ${(value / 1000).toStringAsFixed(1)}K';
    }

    return 'Rs. ${value.toStringAsFixed(0)}';
  }

  void selectExplore(String destination) {
    if (widget.onExploreSelected != null) {
      widget.onExploreSelected!(destination);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$destination page will be connected later.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void selectNavigation(int index) {
    setState(() {
      selectedIndex = index;
    });

    widget.onDestinationSelected?.call(index);
  }

  Widget buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                widget.investorName,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.serif,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => selectExplore('Notifications'),
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.text,
                  size: 21,
                ),
              ),
              Positioned(
                top: 9,
                right: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: AppColors.brass,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPortfolioCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portfolio value',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: widget.portfolioValue),
            duration: const Duration(milliseconds: 1100),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Text(
                'Rs. ${formatNumber(value)}',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Text(
            '▲ Rs. ${formatNumber(widget.dailyGain)} '
            '(${widget.dailyGainPercent.toStringAsFixed(1)}%)',
            style: const TextStyle(
              color: AppColors.gain,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSummaryCards() {
    return Row(
      children: [
        buildSummaryCard('Holdings', widget.holdingsCount.toString()),
        const SizedBox(width: 12),
        buildSummaryCard('Invested', formatCompact(widget.investedAmount)),
      ],
    );
  }

  Widget buildExploreTile(String title, IconData icon) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => selectExplore(title),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.deep,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.brass, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExploreGrid() {
    final items = [
      ('Orders', Icons.format_list_bulleted_rounded),
      ('Trades', Icons.sync_alt_rounded),
      ('Transactions', Icons.receipt_long_outlined),
      ('IPO', Icons.flag_outlined),
      ('Notifications', Icons.notifications_none_rounded),
      ('Profile', Icons.person_outline_rounded),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 104,
      ),
      itemBuilder: (context, index) {
        return buildExploreTile(items[index].$1, items[index].$2);
      },
    );
  }

  Widget buildBottomNavigation() {
    final items = [
      ('Home', Icons.home_outlined),
      ('Portfolio', Icons.pie_chart_outline_rounded),
      ('Market', Icons.show_chart_rounded),
      ('Trade', Icons.swap_vert_rounded),
      ('More', Icons.more_horiz_rounded),
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final selected = selectedIndex == index;
          final color = selected ? AppColors.brass : AppColors.muted;

          return Expanded(
            child: InkWell(
              onTap: () => selectNavigation(index),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (selected)
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 30,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: AppColors.brass,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: selected ? 1.08 : 1,
                        duration: const Duration(milliseconds: 220),
                        child: Icon(items[index].$2, color: color, size: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index].$1,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.maxWidth >= 700
                      ? 32.0
                      : 24.0;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      24,
                      horizontalPadding,
                      28,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            buildHeader(),
                            const SizedBox(height: 22),
                            buildPortfolioCard(),
                            const SizedBox(height: 12),
                            buildSummaryCards(),
                            const SizedBox(height: 22),
                            const Text(
                              'Explore',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            buildExploreGrid(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            buildBottomNavigation(),
          ],
        ),
      ),
    );
  }
}
