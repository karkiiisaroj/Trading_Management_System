import 'package:flutter/material.dart';
import 'package:trading_management_system/core/theme/theme.dart';

class TradeSecurity {
  const TradeSecurity({
    required this.symbol,
    required this.companyName,
    required this.sector,
    required this.price,
    required this.changePercent,
    required this.closeDate,
  });

  final String symbol;
  final String companyName;
  final String sector;
  final double price;
  final double changePercent;
  final String closeDate;
}

class TradeSelectScreen extends StatefulWidget {
  const TradeSelectScreen({
    super.key,
    this.securities = const [
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
    ],
    this.onBack,
    this.onSecuritySelected,
    this.onDestinationSelected,
  });

  final List<TradeSecurity> securities;
  final VoidCallback? onBack;
  final ValueChanged<TradeSecurity>? onSecuritySelected;
  final ValueChanged<int>? onDestinationSelected;

  @override
  State<TradeSelectScreen> createState() => _TradeSelectScreenState();
}

class _TradeSelectScreenState extends State<TradeSelectScreen> {

  final TextEditingController _searchController = TextEditingController();

  String _selectedSector = 'All';
  String _searchQuery = '';

  final List<String> _sectors = const [
    'All',
    'Banks',
    'Hydropower',
    'Insurance',
  ];

  List<TradeSecurity> get _filteredSecurities {
    return widget.securities.where((security) {
      final matchesSector =
          _selectedSector == 'All' || security.sector == _selectedSector;

      final query = _searchQuery.toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          security.symbol.toLowerCase().contains(query) ||
          security.companyName.toLowerCase().contains(query) ||
          security.sector.toLowerCase().contains(query);

      return matchesSector && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final parts = price.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final buffer = StringBuffer();

    for (int i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }

    return '${buffer.toString()}.${parts[1]}';
  }

  void _selectSecurity(TradeSecurity security) {
    if (widget.onSecuritySelected != null) {
      widget.onSecuritySelected!(security);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${security.symbol} selected'),
          backgroundColor: AppColors.surface,
        ),
      );
    }
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
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildHeader(),
                        const SizedBox(height: 16),
                        _buildSearchField(),
                        const SizedBox(height: 14),
                        _buildSectorFilters(),
                        const SizedBox(height: 16),
                        const Text(
                          'Last close by trading date (historical)',
                          style: TextStyle(color: AppColors.muted, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                      ]),
                    ),
                  ),
                  if (_filteredSecurities.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptySearch(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final security = _filteredSecurities[index];

                          return _buildSecurityRow(security);
                        }, childCount: _filteredSecurities.length),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 34,
              height: 44,
              child: IconButton(
                onPressed: widget.onBack ?? () => Navigator.maybePop(context),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.chevron_left, color: AppColors.text, size: 30),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'Select security',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 30,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 34, top: 2),
          child: Text(
            'Choose what you want to trade',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
        style: const TextStyle(color: AppColors.text, fontSize: 14),
        cursorColor: AppColors.brass,
        decoration: InputDecoration(
          hintText: 'Search securities',
          hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.muted, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.close, color: AppColors.muted, size: 18),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
      ),
    );
  }

  Widget _buildSectorFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _sectors.map((sector) {
          final selected = _selectedSector == sector;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSector = sector;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.brass : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: selected ? AppColors.brass : AppColors.border),
                ),
                child: Text(
                  sector,
                  style: TextStyle(
                    color: selected ? AppColors.onBrass : AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSecurityRow(TradeSecurity security) {
    final isPositive = security.changePercent >= 0;
    final changeColor = isPositive ? AppColors.gain : AppColors.loss;

    return InkWell(
      onTap: () => _selectSecurity(security),
      splashColor: AppColors.brass.withValues(alpha: 0.08),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    security.symbol,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    security.companyName,
                    style: const TextStyle(color: AppColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rs. ${_formatPrice(security.price)}',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      isPositive ? '▲ ' : '▼ ',
                      style: TextStyle(color: changeColor, fontSize: 11),
                    ),
                    Text(
                      '${security.changePercent.abs().toStringAsFixed(1)}%',
                      style: TextStyle(color: changeColor, fontSize: 12),
                    ),
                    const Text(
                      ' · ',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                    Text(
                      security.closeDate,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, color: AppColors.muted, size: 38),
            const SizedBox(height: 12),
            const Text(
              'No securities found',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try another company name or symbol.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedSector = 'All';
                });
              },
              child: const Text(
                'Clear filters',
                style: TextStyle(color: AppColors.brass, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    const items = [
      _NavItem(Icons.home_outlined, 'Home'),
      _NavItem(Icons.pie_chart_outline, 'Portfolio'),
      _NavItem(Icons.show_chart, 'Market'),
      _NavItem(Icons.swap_vert, 'Trade'),
      _NavItem(Icons.more_horiz, 'More'),
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: AppColors.deep,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final selected = index == 3;

          return Expanded(
            child: InkWell(
              onTap: () => widget.onDestinationSelected?.call(index),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: selected ? AppColors.brass : AppColors.muted, size: 22),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: selected ? AppColors.brass : AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
