import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/animations.dart';
import '../../../../core/widgets/investor_bottom_nav.dart';
import '../trades/select/trade_select_screen.dart';

/// Market tab: browse and search securities.
///
/// BR-I11: only securities available to the investor are listed.
/// BR-I15: prices are the last historical close, never presented as live.
class InvestorMarketScreen extends StatefulWidget {
  const InvestorMarketScreen({
    super.key,
    this.securities = _defaultSecurities,
    this.asOf = '08 Oct',
    this.onSecuritySelected,
    this.onDestinationSelected,
  });

  final List<TradeSecurity> securities;

  /// Trading date of the closing prices shown.
  final String asOf;

  final ValueChanged<TradeSecurity>? onSecuritySelected;
  final ValueChanged<int>? onDestinationSelected;

  static const List<TradeSecurity> _defaultSecurities = [
    TradeSecurity(
      symbol: 'ABCD',
      companyName: 'Sample Bank Ltd',
      sector: 'Banks',
      price: 512.00,
      changePercent: 1.2,
      closeDate: '08 Oct',
    ),
    TradeSecurity(
      symbol: 'EFGH',
      companyName: 'Sample Hydropower Ltd',
      sector: 'Hydropower',
      price: 298.40,
      changePercent: -0.8,
      closeDate: '08 Oct',
    ),
    TradeSecurity(
      symbol: 'IJKL',
      companyName: 'Sample Insurance Ltd',
      sector: 'Insurance',
      price: 905.10,
      changePercent: 2.1,
      closeDate: '08 Oct',
    ),
    TradeSecurity(
      symbol: 'MNOP',
      companyName: 'Sample Finance Ltd',
      sector: 'Finance',
      price: 221.00,
      changePercent: -0.3,
      closeDate: '08 Oct',
    ),
  ];

  @override
  State<InvestorMarketScreen> createState() => _InvestorMarketScreenState();
}

class _InvestorMarketScreenState extends State<InvestorMarketScreen> {
  String _query = '';

  List<TradeSecurity> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.securities;
    return widget.securities
        .where(
          (s) =>
              s.symbol.toLowerCase().contains(q) ||
              s.companyName.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: [
                  Text('Market', style: AppTypography.heading).fadeUp(0),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Closing prices · ${widget.asOf}',
                    style: AppTypography.label,
                  ).fadeUp(1),
                  const SizedBox(height: AppSpacing.l),
                  _SearchField(onChanged: (v) => setState(() => _query = v)).fadeUp(2),
                  const SizedBox(height: AppSpacing.m),
                  const _HistoricalNote().fadeUp(3),
                  const SizedBox(height: AppSpacing.l),
                  if (results.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xxl),
                      child: Center(
                        child: Text(
                          'No securities match "$_query"',
                          style: AppTypography.bodyMuted,
                        ),
                      ),
                    )
                  else
                    for (final (i, s) in results.indexed)
                      Padding(
                        key: ValueKey(s.symbol),
                        padding: const EdgeInsets.only(bottom: AppSpacing.m),
                        child: PressScale(
                          child: _SecurityRow(
                            security: s,
                            onTap: () => widget.onSecuritySelected?.call(s),
                          ),
                        ),
                      ).fadeUp(i + 4, 100),
                ],
              ),
            ),
            InvestorBottomNav(
              selectedIndex: InvestorTab.market.index,
              onSelected: widget.onDestinationSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: AppTypography.input,
      cursorColor: AppColors.brass,
      decoration: InputDecoration(
        hintText: 'Search symbol or company',
        hintStyle: AppTypography.bodyMuted,
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.brass),
        ),
      ),
    );
  }
}

class _HistoricalNote extends StatelessWidget {
  const _HistoricalNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.history_rounded, size: 16, color: AppColors.muted),
        const SizedBox(width: AppSpacing.s),
        Expanded(
          child: Text(
            'Historical data from the last close, not live prices.',
            style: AppTypography.caption,
          ),
        ),
      ],
    );
  }
}

class _SecurityRow extends StatelessWidget {
  const _SecurityRow({required this.security, required this.onTap});

  final TradeSecurity security;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final up = security.changePercent >= 0;
    final color = up ? AppColors.gain : AppColors.loss;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      security.symbol,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${security.companyName} · ${security.sector}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    security.price.toStringAsFixed(2),
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${up ? '▲' : '▼'} ${security.changePercent.abs().toStringAsFixed(1)}%',
                    style: AppTypography.caption.copyWith(color: color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
