import 'package:flutter/material.dart';

const Color _background = Color(0xFF18372B);
const Color _card = Color(0xFF1F4435);
const Color _navigation = Color(0xFF12291F);
const Color _border = Color(0xFF34584A);
const Color _gold = Color(0xFFC4A76C);
const Color _primaryText = Color(0xFFF4F1E9);
const Color _mutedText = Color(0xFFB5C3B9);
const Color _positive = Color(0xFF7BE0B0);

class BrokerOrderUpdateScreen extends StatefulWidget {
  const BrokerOrderUpdateScreen({super.key});

  @override
  State<BrokerOrderUpdateScreen> createState() =>
      _BrokerOrderUpdateScreenState();
}

class _BrokerOrderUpdateScreenState extends State<BrokerOrderUpdateScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatusFilter = 'All';
  bool _showUpdateDialog = true;

  final List<_OrderRecord> _orders = [
    _OrderRecord('#1042', 'C001', 'ABCD', 'Buy', '50', 'Rs. 512.00', 'Pending'),
    _OrderRecord(
      '#1041',
      'C002',
      'EFGH',
      'Sell',
      '120',
      'Rs. 298.40',
      'Filled',
    ),
    _OrderRecord('#1040', 'C001', 'IJKL', 'Buy', '30', 'Rs. 905.10', 'Partial'),
    _OrderRecord(
      '#1039',
      'C003',
      'MNOP',
      'Buy',
      '200',
      'Rs. 221.00',
      'Cancelled',
    ),
  ];

  _OrderRecord get _targetOrder => _orders.first;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_OrderRecord> get _visibleOrders {
    final query = _searchController.text.trim().toLowerCase();
    return _orders.where((order) {
      final matchesQuery =
          query.isEmpty ||
          order.number.toLowerCase().contains(query) ||
          order.clientId.toLowerCase().contains(query) ||
          order.security.toLowerCase().contains(query);
      final matchesStatus =
          _selectedStatusFilter == 'All' ||
          order.status == _selectedStatusFilter;
      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 860;
        return Scaffold(
          backgroundColor: _background,
          drawer: isMobile
              ? Drawer(
                  backgroundColor: _navigation,
                  child: SafeArea(
                    child: _buildSidebar(context, inDrawer: true),
                  ),
                )
              : null,
          body: Row(
            children: [
              if (!isMobile)
                SizedBox(width: 240, child: _buildSidebar(context)),
              Expanded(
                child: SafeArea(
                  child: Column(
                    children: [
                      if (isMobile) _buildMobileBar(context),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 18 : 40,
                            vertical: 28,
                          ),
                          child: _buildPageContent(isMobile),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_showUpdateDialog)
                Positioned.fill(
                  child: _UpdateOrderOverlay(
                    order: _targetOrder,
                    initialStatus: 'Filled',
                    onCancel: () => setState(() => _showUpdateDialog = false),
                    onSave: (newStatus) {
                      setState(() {
                        _targetOrder.status = newStatus;
                        _showUpdateDialog = false;
                      });
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, {bool inDrawer = false}) {
    const items = [
      _SideItem('Dashboard', Icons.grid_view_rounded),
      _SideItem('Investors', Icons.people_outline),
      _SideItem('Trading accounts', Icons.account_balance_wallet_outlined),
      _SideItem('Orders', Icons.format_list_bulleted, active: true),
      _SideItem('Trades', Icons.sync_alt),
      _SideItem('Market', Icons.show_chart),
      _SideItem('Securities', Icons.layers_outlined),
      _SideItem('Notifications', Icons.notifications_none),
      _SideItem('Profile', Icons.person_outline),
    ];

    return Container(
      color: _navigation,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 24),
            child: Row(
              children: [
                _BrandMark(),
                SizedBox(width: 12),
                Text(
                  'AARTHA',
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (inDrawer) Navigator.of(context).pop();
                  if (!item.active) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${item.label} screen is not connected here yet.',
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: item.active ? _card : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 20,
                        color: item.active ? _gold : _mutedText,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: item.active ? _gold : _mutedText,
                          fontSize: 14,
                          fontWeight: item.active
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          const Divider(color: _border),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '[Broker name]',
                  style: TextStyle(
                    color: _primaryText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Broker',
                  style: TextStyle(color: _mutedText, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: _navigation,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          Builder(
            builder: (drawerContext) => IconButton(
              onPressed: () => Scaffold.of(drawerContext).openDrawer(),
              icon: const Icon(Icons.menu, color: _primaryText),
            ),
          ),
          const Text(
            'AARTHA',
            style: TextStyle(
              color: _primaryText,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
            ),
          ),
          const Spacer(),
          const CircleAvatar(
            backgroundColor: _card,
            child: Text('BR', style: TextStyle(color: _gold, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(bool isMobile) {
    final visibleOrders = _visibleOrders;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Orders',
                    style: TextStyle(
                      color: _primaryText,
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Monitor and manage orders from your investors',
                    style: TextStyle(color: _mutedText, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (!isMobile) ...[
              _circleIcon(Icons.notifications_none),
              const SizedBox(width: 12),
              _circleAvatar(),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: isMobile ? double.infinity : 420,
              height: 46,
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: _primaryText, fontSize: 14),
                decoration: _inputDecoration(
                  hint: 'Search by order, client or security',
                  icon: Icons.search,
                ),
              ),
            ),
            SizedBox(
              width: isMobile ? double.infinity : 190,
              height: 46,
              child: DropdownButtonFormField<String>(
                value: _selectedStatusFilter,
                dropdownColor: _card,
                style: const TextStyle(color: _primaryText, fontSize: 14),
                iconEnabledColor: _mutedText,
                decoration: _inputDecoration(label: 'Status'),
                items:
                    const [
                          'All',
                          'Pending',
                          'Partial',
                          'Filled',
                          'Cancelled',
                          'Rejected',
                        ]
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStatusFilter = value);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _card,
            border: Border.all(color: _border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: visibleOrders.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(28),
                  child: Center(
                    child: Text(
                      'No orders found.',
                      style: TextStyle(color: _mutedText),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 900,
                    child: Column(
                      children: [
                        const _OrderTableRow(
                          header: true,
                          values: [
                            'Order',
                            'Client ID',
                            'Security',
                            'Type',
                            'Quantity',
                            'Price',
                            'Status',
                            '',
                          ],
                        ),
                        ...visibleOrders.map(
                          (order) => _OrderTableRow(
                            values: [
                              order.number,
                              order.clientId,
                              order.security,
                              order.type,
                              order.quantity,
                              order.price,
                              order.status,
                              order.number == '#1041' || order.number == '#1039'
                                  ? 'View'
                                  : 'Update status',
                            ],
                            status: order.status,
                            onAction: () {
                              if (order.number == '#1042' ||
                                  order.number == '#1040') {
                                setState(() => _showUpdateDialog = true);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Sample data',
          style: TextStyle(color: _mutedText, fontSize: 11),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    String? hint,
    String? label,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      hintStyle: const TextStyle(color: _mutedText, fontSize: 14),
      labelStyle: const TextStyle(color: _mutedText),
      prefixIcon: icon == null ? null : Icon(icon, color: _mutedText, size: 19),
      filled: true,
      fillColor: _card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _gold),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _card,
        shape: BoxShape.circle,
        border: Border.all(color: _border),
      ),
      child: Icon(icon, color: _primaryText, size: 20),
    );
  }

  Widget _circleAvatar() {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _card,
        shape: BoxShape.circle,
        border: Border.all(color: _border),
      ),
      child: const Text(
        'BR',
        style: TextStyle(color: _gold, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _UpdateOrderOverlay extends StatefulWidget {
  const _UpdateOrderOverlay({
    required this.order,
    required this.initialStatus,
    required this.onCancel,
    required this.onSave,
  });

  final _OrderRecord order;
  final String initialStatus;
  final VoidCallback onCancel;
  final ValueChanged<String> onSave;

  @override
  State<_UpdateOrderOverlay> createState() => _UpdateOrderOverlayState();
}

class _UpdateOrderOverlayState extends State<_UpdateOrderOverlay> {
  late String _selectedStatus;

  static const List<String> _statuses = [
    'Pending',
    'Partial',
    'Filled',
    'Cancelled',
    'Rejected',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.72),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 440,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: _card,
              border: Border.all(color: _border),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Update order #1042',
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.order.security} · ${widget.order.type} · '
                  '${widget.order.quantity} units · Client ${widget.order.clientId}',
                  style: const TextStyle(color: _mutedText, fontSize: 13),
                ),
                const SizedBox(height: 20),
                const Text(
                  'New status',
                  style: TextStyle(color: _mutedText, fontSize: 13),
                ),
                const SizedBox(height: 8),
                ..._statuses.map(_buildStatusOption),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryText,
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: _border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => widget.onSave(_selectedStatus),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _gold,
                          foregroundColor: _navigation,
                          minimumSize: const Size.fromHeight(48),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Save status',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusOption(String status) {
    final selected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _selectedStatus = status),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? _gold.withOpacity(0.12) : Colors.transparent,
            border: Border.all(color: selected ? _gold : _border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? _gold : _mutedText,
                size: 19,
              ),
              const SizedBox(width: 12),
              Text(
                status,
                style: const TextStyle(color: _primaryText, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderTableRow extends StatelessWidget {
  const _OrderTableRow({
    required this.values,
    this.header = false,
    this.status,
    this.onAction,
  });

  final List<String> values;
  final bool header;
  final String? status;
  final VoidCallback? onAction;

  static const List<double> _widths = [90, 100, 110, 75, 85, 120, 100, 140];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: List.generate(values.length, (index) {
          Widget content;
          if (!header && index == 6) {
            content = _StatusLabel(status: status ?? values[index]);
          } else if (!header && index == 7) {
            content = Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: _gold,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  values[index],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          } else {
            content = Text(
              values[index],
              style: TextStyle(
                color: header ? _mutedText : _primaryText,
                fontSize: header ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            );
          }
          return SizedBox(width: _widths[index], child: content);
        }),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = status == 'Filled'
        ? _positive
        : status == 'Cancelled' || status == 'Rejected'
        ? _mutedText
        : _gold;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(status, style: TextStyle(color: color, fontSize: 12)),
      ),
    );
  }
}

class _OrderRecord {
  _OrderRecord(
    this.number,
    this.clientId,
    this.security,
    this.type,
    this.quantity,
    this.price,
    this.status,
  );

  final String number;
  final String clientId;
  final String security;
  final String type;
  final String quantity;
  final String price;
  String status;
}

class _SideItem {
  const _SideItem(this.label, this.icon, {this.active = false});

  final String label;
  final IconData icon;
  final bool active;
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: _background,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.account_balance, color: _gold),
    );
  }
}
