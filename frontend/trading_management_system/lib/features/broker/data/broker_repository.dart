import '../../trade_desk/trade_desk.dart';
import 'broker_models.dart';

/// Everything the broker screens read or change.
///
/// The broker is identified from the authenticated session when the
/// repository is created, never from a parameter on these methods (BR-08,
/// BR-S03). Every list is already limited to this broker's investors,
/// accounts and securities (BR-B05, BR-B19, BR-S05).
///
/// Swap [DemoBrokerRepository] for a class that calls the Django API and
/// nothing else in `features/broker` has to change.
abstract class BrokerRepository {
  /// Also the access gate: throws [BrokerInactive] for an inactive broker.
  Future<BrokerProfile> profile();

  Future<DashboardSummary> dashboard();

  Future<List<BrokerInvestor>> investors();

  /// Throws [BrokerAccessDenied] when [clientId] is not assigned (BR-B09).
  Future<InvestorDetails> investorDetails(String clientId);

  Future<List<BrokerAccount>> accounts();

  Future<List<BrokerOrder>> orders();

  /// Throws [BrokerAccessDenied] for an order outside the broker's scope and
  /// [BrokerRuleViolation] when the change is not allowed (BR-I29, BR-B12).
  Future<BrokerOrder> updateOrderStatus(String orderNumber, OrderStatus status);

  Future<List<BrokerTrade>> trades();

  Future<List<BrokerTransaction>> transactions();

  /// Historical records only, never live data (BR-I15, BR-M02).
  Future<List<MarketRow>> market();

  Future<List<BrokerSecurity>> securities();

  Future<List<BrokerNotification>> notifications();

  Future<List<BrokerActivity>> activity();
}

/// In-memory data so the whole broker area can be used before the API exists.
///
/// Includes an investor (`C900`) and an order that belong to another broker,
/// to show that they never reach this broker's screens. Broker `B002` is
/// inactive and sees the inactive state.
class DemoBrokerRepository implements BrokerRepository {
  DemoBrokerRepository({
    required this.brokerCode,
    required this.displayName,
    required this.username,
    required this.desk,
    this.latency = const Duration(milliseconds: 350),
  });

  final String brokerCode;
  final String displayName;
  final String username;

  /// The shared order book. Orders the investors request land here as
  /// Pending; this repository is the only place that decides them.
  final TradeDesk desk;

  /// Fake network delay, so loading states are visible. Use zero in tests.
  final Duration latency;

  static const String inactiveBrokerCode = 'B002';

  // ---- assignments (BrokerInvestorAssignment / BrokerSecurityAssignment) ---

  static const Map<String, Set<String>> _investorAssignments = {
    'B001': {'C001', 'C002', 'C003', 'C004', 'C005', 'C006'},
    'B002': {'C001'},
  };

  static const Map<String, Set<String>> _securityAssignments = {
    'B001': {'ABCD', 'EFGH', 'IJKL', 'MNOP', 'QRST'},
    'B002': {'ABCD'},
  };

  Set<String> get _clients => _investorAssignments[brokerCode] ?? const {};
  Set<String> get _symbols => _securityAssignments[brokerCode] ?? const {};
  bool get _isActive => brokerCode != inactiveBrokerCode;

  Future<void> _guard() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    if (!_isActive) throw const BrokerInactive();
  }

  // ---- demo data -----------------------------------------------------------

  static const List<BrokerInvestor> _allInvestors = [
    BrokerInvestor(clientId: 'C001', name: 'Sample Investor 1', email: 'investor1@example.com', phone: '+977 9800000001', accountNumber: 'A001', isActive: true, assignedSince: '12 Jan 2026'),
    BrokerInvestor(clientId: 'C002', name: 'Sample Investor 2', email: 'investor2@example.com', phone: '+977 9800000002', accountNumber: 'A002', isActive: true, assignedSince: '03 Feb 2026'),
    BrokerInvestor(clientId: 'C003', name: 'Sample Investor 3', email: 'investor3@example.com', phone: '+977 9800000003', accountNumber: 'A003', isActive: true, assignedSince: '21 Feb 2026'),
    BrokerInvestor(clientId: 'C004', name: 'Sample Investor 4', email: 'investor4@example.com', phone: '+977 9800000004', accountNumber: 'A004', isActive: false, assignedSince: '09 Mar 2026'),
    BrokerInvestor(clientId: 'C005', name: 'Sample Investor 5', email: 'investor5@example.com', phone: '+977 9800000005', accountNumber: 'A005', isActive: true, assignedSince: '30 Mar 2026'),
    BrokerInvestor(clientId: 'C006', name: 'Sample Investor 6', email: 'investor6@example.com', phone: '+977 9800000006', accountNumber: 'A006', isActive: true, assignedSince: '07 Oct 2026'),
    // Not assigned to B001 / B002: must never be visible to them.
    BrokerInvestor(clientId: 'C900', name: 'Other Broker Investor', email: 'other@example.com', phone: '+977 9800000900', accountNumber: 'A900', isActive: true, assignedSince: '01 Jan 2026'),
  ];

  /// Average cost per investor and security. Quantities come from the desk,
  /// because only executed trades change them.
  static const Map<String, Map<String, double>> _averageCost = {
    'C001': {'ABCD': 420.00, 'EFGH': 310.50, 'IJKL': 890.00, 'MNOP': 215.25},
    'C002': {'EFGH': 295.00, 'IJKL': 880.00},
    'C003': {'MNOP': 218.00, 'ABCD': 495.00, 'QRST': 150.00},
    'C005': {'ABCD': 510.00},
    'C006': {'IJKL': 900.00, 'EFGH': 300.00, 'MNOP': 220.00, 'ABCD': 505.00, 'QRST': 148.00},
  };

  List<BrokerHolding> _holdingsOf(String clientId) => [
        for (final e in desk.holdingsOf(clientId).entries)
          BrokerHolding(
            symbol: e.key,
            quantity: e.value,
            averageCost: _averageCost[clientId]?[e.key] ?? _lastClose(e.key),
          ),
      ];

  static const List<BrokerSecurity> _allSecurities = [
    BrokerSecurity(symbol: 'ABCD', company: 'Sample Bank Ltd', type: 'Equity', isin: 'INE000000001', lastClose: 512.00, isActive: true),
    BrokerSecurity(symbol: 'EFGH', company: 'Sample Hydropower Ltd', type: 'Equity', isin: 'INE000000002', lastClose: 298.40, isActive: true),
    BrokerSecurity(symbol: 'IJKL', company: 'Sample Insurance Ltd', type: 'Equity', isin: 'INE000000003', lastClose: 905.10, isActive: true),
    BrokerSecurity(symbol: 'MNOP', company: 'Sample Finance Ltd', type: 'Equity', isin: 'INE000000004', lastClose: 221.00, isActive: true),
    BrokerSecurity(symbol: 'QRST', company: 'Sample Hotels Ltd', type: 'Equity', isin: 'INE000000005', lastClose: 149.80, isActive: false),
    BrokerSecurity(symbol: 'ZZZZ', company: 'Unassigned Co Ltd', type: 'Equity', isin: 'INE000000099', lastClose: 80.00, isActive: true),
  ];

  /// Older history; new events come from the desk.
  static const List<BrokerActivity> _history = [
    BrokerActivity(time: '10:42', action: 'Order placed', clientId: 'C001', details: 'Buy order #1042 for 50 units of ABCD'),
    BrokerActivity(time: '10:15', action: 'Status updated', clientId: 'C002', details: 'Order #1041 changed from Pending to Executed'),
    BrokerActivity(time: '09:58', action: 'Trade recorded', clientId: 'C002', details: 'Trade T-501 for 120 units of EFGH at Rs. 298.40'),
    BrokerActivity(time: '09:30', action: 'IPO application', clientId: 'C003', details: 'Applied for 20 units of Sample Bank IPO'),
    BrokerActivity(time: 'Yesterday', action: 'Order cancelled', clientId: 'C005', details: 'Order #1039 for MNOP was cancelled'),
    BrokerActivity(time: 'Yesterday', action: 'Investor assigned', clientId: 'C006', details: 'Sample Investor 6 was assigned to you'),
  ];

  static const List<BrokerNotification> _notifications = [
    BrokerNotification(kind: NotificationKind.order, title: 'New order', message: 'C001 placed a buy order for 50 units of ABCD.', time: '2 hours ago'),
    BrokerNotification(kind: NotificationKind.trade, title: 'Trade executed', message: 'Order #1041 for EFGH was executed.', time: '3 hours ago'),
    BrokerNotification(kind: NotificationKind.transaction, title: 'Transaction completed', message: 'Settlement for C002 is complete.', time: 'Yesterday'),
    BrokerNotification(kind: NotificationKind.ipo, title: 'IPO open', message: 'Sample Bank IPO is open for your investors.', time: '07 Oct'),
    BrokerNotification(kind: NotificationKind.system, title: 'System notice', message: 'Welcome to AARTHA.', time: '03 Oct'),
  ];

  // ---- scoped views --------------------------------------------------------

  List<BrokerInvestor> _myInvestors() => [
        for (final i in _allInvestors)
          if (_clients.contains(i.clientId))
            i.withHoldings(desk.holdingsOf(i.clientId).length),
      ];

  /// Orders of this broker's investors that were routed to this broker.
  List<BrokerOrder> _myOrders() => desk.orders
      .where((o) => _clients.contains(o.clientId) && desk.routedTo(o, brokerCode))
      .toList();

  List<BrokerSecurity> _mySecurities() =>
      _allSecurities.where((s) => _symbols.contains(s.symbol)).toList();

  double _lastClose(String symbol) => _allSecurities
      .firstWhere(
        (s) => s.symbol == symbol,
        orElse: () => _allSecurities.first,
      )
      .lastClose;

  int _openOrdersFor(String clientId) =>
      _myOrders().where((o) => o.clientId == clientId && o.status.isOpen).length;

  // ---- BrokerRepository ----------------------------------------------------

  @override
  Future<BrokerProfile> profile() async {
    await _guard();
    return BrokerProfile(
      name: displayName,
      brokerCode: brokerCode,
      username: username,
      email: '${username.toLowerCase()}@aartha.example',
      phone: '+977 9800000100',
      assignedInvestors: _clients.length,
    );
  }

  @override
  Future<DashboardSummary> dashboard() async {
    await _guard();
    final mine = _myOrders();
    return DashboardSummary(
      assignedInvestors: _clients.length,
      tradingAccounts: _myInvestors().length,
      pendingOrders: mine.where((o) => o.status == OrderStatus.pending).length,
      assignedSecurities: _symbols.length,
      recentOrders: mine.take(5).toList(),
    );
  }

  @override
  Future<List<BrokerInvestor>> investors() async {
    await _guard();
    return _myInvestors();
  }

  @override
  Future<InvestorDetails> investorDetails(String clientId) async {
    await _guard();
    if (!_clients.contains(clientId)) throw const BrokerAccessDenied();
    final investor =
        _myInvestors().firstWhere((i) => i.clientId == clientId);
    final holdings = _holdingsOf(clientId);
    final value = holdings.fold<double>(
      0,
      (sum, h) => sum + h.quantity * _lastClose(h.symbol),
    );
    return InvestorDetails(
      investor: investor,
      holdings: holdings,
      recentOrders:
          _myOrders().where((o) => o.clientId == clientId).take(3).toList(),
      portfolioValue: value,
      openOrders: _openOrdersFor(clientId),
    );
  }

  @override
  Future<List<BrokerAccount>> accounts() async {
    await _guard();
    return [
      for (final i in _myInvestors())
        BrokerAccount(
          accountNumber: i.accountNumber,
          investorName: i.name,
          clientId: i.clientId,
          openOrders: _openOrdersFor(i.clientId),
          isActive: i.isActive,
        ),
    ];
  }

  @override
  Future<List<BrokerOrder>> orders() async {
    await _guard();
    return _myOrders();
  }

  @override
  Future<BrokerOrder> updateOrderStatus(
    String orderNumber,
    OrderStatus status,
  ) async {
    await _guard();
    BrokerOrder? order;
    for (final o in _myOrders()) {
      if (o.orderNumber == orderNumber) order = o;
    }
    if (order == null) throw const BrokerAccessDenied();

    // BR-B12: only an active trading account can be used for trading work.
    final investor =
        _allInvestors.firstWhere((i) => i.clientId == order!.clientId);
    if (!investor.isActive) {
      throw const BrokerRuleViolation(
        'The trading account for this order is inactive, so the order '
        "can't be changed.",
      );
    }

    // BR-I29 / BR-B15 and the sell-holdings check live in the desk.
    try {
      return desk.applyBrokerStatus(orderNumber, status);
    } on TradeDeskError catch (e) {
      throw BrokerRuleViolation(e.message);
    }
  }

  @override
  Future<List<BrokerTrade>> trades() async {
    await _guard();
    final mine = {for (final o in _myOrders()) o.orderNumber};
    return desk.trades
        .where((t) => _clients.contains(t.clientId) && mine.contains(t.orderNumber))
        .toList();
  }

  /// One transaction per trade (BR-I34); its type follows the order (BR-I35).
  @override
  Future<List<BrokerTransaction>> transactions() async {
    await _guard();
    final result = <BrokerTransaction>[];
    final mine = {for (final o in _myOrders()) o.orderNumber: o};
    for (final t in desk.trades) {
      final order = mine[t.orderNumber];
      if (order == null) continue;
      final value = t.quantity * t.price;
      final tradeSeq = int.parse(t.tradeNumber.substring(2));
      result.add(
        BrokerTransaction(
          transactionNumber: 'T${tradeSeq + 1530}',
          tradeNumber: t.tradeNumber,
          clientId: t.clientId,
          symbol: t.symbol,
          isBuy: order.isBuy,
          amount: order.isBuy ? -value : value,
          isCompleted: t.status == OrderStatus.executed,
          date: t.date,
        ),
      );
    }
    return result;
  }

  static const List<MarketRow> _latestMarket = [
    MarketRow(symbol: 'ABCD', date: '08 Oct', tradingDate: '08 Oct 2026', open: 506.00, high: 515.00, low: 503.50, close: 512.00, volume: 12400),
    MarketRow(symbol: 'EFGH', date: '08 Oct', tradingDate: '08 Oct 2026', open: 300.80, high: 302.00, low: 296.10, close: 298.40, volume: 31250),
    MarketRow(symbol: 'IJKL', date: '08 Oct', tradingDate: '08 Oct 2026', open: 886.50, high: 909.00, low: 884.00, close: 905.10, volume: 4980),
    MarketRow(symbol: 'MNOP', date: '08 Oct', tradingDate: '08 Oct 2026', open: 221.70, high: 223.00, low: 219.50, close: 221.00, volume: 58100),
    MarketRow(symbol: 'QRST', date: '08 Oct', tradingDate: '08 Oct 2026', open: 147.00, high: 150.40, low: 146.20, close: 149.80, volume: 22760),
  ];

  /// Security + trading date is unique (BR-I16), so each date has one row per
  /// security.
  @override
  Future<List<MarketRow>> market() async {
    await _guard();
    final previous = [
      for (final r in _latestMarket)
        MarketRow(
          symbol: r.symbol,
          date: '07 Oct',
          tradingDate: '07 Oct 2026',
          open: r.open * 0.99,
          high: r.high * 0.995,
          low: r.low * 0.985,
          close: r.open,
          volume: (r.volume * 0.9).round(),
        ),
    ];
    return [
      for (final r in [..._latestMarket, ...previous])
        if (_symbols.contains(r.symbol)) r,
    ];
  }

  @override
  Future<List<BrokerSecurity>> securities() async {
    await _guard();
    return _mySecurities();
  }

  @override
  Future<List<BrokerNotification>> notifications() async {
    await _guard();
    return _notifications;
  }

  @override
  Future<List<BrokerActivity>> activity() async {
    await _guard();
    final mine = {for (final o in _myOrders()) o.clientId};
    return [
      for (final e in desk.events)
        if (mine.contains(e.clientId))
          BrokerActivity(
            time: e.time,
            action: e.action,
            clientId: e.clientId,
            details: e.details,
          ),
      ..._history.where((a) => _clients.contains(a.clientId)),
    ];
  }
}
