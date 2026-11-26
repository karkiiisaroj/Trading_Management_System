import 'package:flutter/foundation.dart';

import '../broker/data/broker_models.dart';
import 'trade_rules.dart';

export 'trade_rules.dart';

// ---------------------------------------------------------------------------
// Records
// ---------------------------------------------------------------------------

/// A trading account as the desk knows it (BR-B10: one investor, one broker).
class DeskAccount {
  const DeskAccount({
    required this.accountNumber,
    required this.brokerCode,
    required this.brokerName,
    required this.isActive,
  });

  final String accountNumber;
  final String brokerCode;
  final String brokerName;
  final bool isActive;
}

/// What the desk needs to know about a security to validate an order.
class DeskSecurity {
  const DeskSecurity({
    required this.symbol,
    required this.lastClose,
    this.isActive = true,
  });

  final String symbol;

  /// Last historical close (BR-I15), the centre of the allowed price band.
  final double lastClose;
  final bool isActive;
}

/// One line of the broker's activity history.
class DeskEvent {
  const DeskEvent({
    required this.time,
    required this.action,
    required this.clientId,
    required this.details,
  });

  final String time;
  final String action;
  final String clientId;
  final String details;
}

/// Extra facts the desk keeps about an order it created.
class OrderMeta {
  const OrderMeta({
    required this.accountNumber,
    required this.brokerCode,
    required this.createdAt,
    this.reason,
  });

  final String accountNumber;

  /// The broker that manages the account; only this broker sees the order.
  final String brokerCode;
  final String createdAt;

  /// Why the order was rejected, when it was.
  final String? reason;
}

/// What the app sends. Note what is *not* here: no investor id, no status, no
/// order number. The desk derives the investor from the signed-in session
/// (BR-08) and always creates the order as Pending.
class OrderRequest {
  const OrderRequest({
    required this.requestId,
    required this.accountNumber,
    required this.symbol,
    required this.action,
    required this.quantity,
    required this.pricePerUnit,
    required this.authorization,
  });

  /// One per submit attempt, so a double tap or a retry cannot create two
  /// orders (idempotency).
  final String requestId;
  final String accountNumber;
  final String symbol;
  final String action;
  final int quantity;
  final double pricePerUnit;

  /// Single-use approval from [TradeDesk.verifyPin], bound to these exact
  /// order details.
  final String authorization;

  bool get isBuy => action.toLowerCase() == 'buy';
}

class SubmitResult {
  const SubmitResult.accepted(BrokerOrder this.order)
      : refusal = null,
        duplicate = false;

  const SubmitResult.repeat(BrokerOrder this.order)
      : refusal = null,
        duplicate = true;

  const SubmitResult.refused(TradeRefusal this.refusal, {this.order})
      : duplicate = false;

  /// The created order. For a refusal it is the Rejected record, if any.
  final BrokerOrder? order;
  final TradeRefusal? refusal;

  /// True when this was a repeat of an earlier request (same [requestId]).
  final bool duplicate;

  bool get accepted => refusal == null;
}

class PinResult {
  const PinResult._({
    this.authorization,
    this.attemptsLeft = 0,
    this.lockedUntil,
  });

  const PinResult.approved(String token) : this._(authorization: token);

  const PinResult.wrong(int attemptsLeft) : this._(attemptsLeft: attemptsLeft);

  const PinResult.locked(DateTime until) : this._(lockedUntil: until);

  final String? authorization;
  final int attemptsLeft;
  final DateTime? lockedUntil;

  bool get approved => authorization != null;
  bool get isLocked => lockedUntil != null;
}

class CancelResult {
  const CancelResult({required this.cancelled, required this.order});

  final bool cancelled;

  /// The order after the attempt; null when it isn't this investor's.
  final BrokerOrder? order;
}

/// A rule the desk will not let anyone break, even a broker.
class TradeDeskError implements Exception {
  const TradeDeskError(this.message);

  final String message;

  @override
  String toString() => message;
}

// ---------------------------------------------------------------------------
// The desk
// ---------------------------------------------------------------------------

/// One order book shared by the investor and the broker apps. In production
/// this is the Django backend; here it is in memory so both sides can be used
/// together before the API exists.
///
/// ```
/// Investor app                TradeDesk                    Broker app
///   verifyPin ────────────►  approval token
///   submit(order+token) ──►  re-checks every rule
///                            creates order as PENDING ────► sees it, decides
///   cancel (if Pending) ──►                                 applyBrokerStatus
///                            only here: trades + holdings ◄─ Executed/Partial
/// ```
///
/// The investor can never move an order past Pending, create a trade, or edit
/// holdings. Only [applyBrokerStatus] does that, and the broker repository
/// only calls it for orders of the broker's own investors.
class TradeDesk extends ChangeNotifier {
  TradeDesk({
    required List<BrokerOrder> orders,
    required List<BrokerTrade> trades,
    required this.accounts,
    required this.securities,
    required Map<String, Map<String, int>> holdings,
    this.brokerSecurities = const {},
    Map<String, String> pins = const {},
    this.limits = const TradeLimits(),
    DateTime Function()? clock,
  })  : _orders = [...orders],
        _trades = [...trades],
        _holdings = {
          for (final e in holdings.entries) e.key: {...e.value},
        },
        _pins = {...pins},
        _clock = clock ?? DateTime.now;

  final Map<String, List<DeskAccount>> accounts;
  final Map<String, DeskSecurity> securities;

  /// Which securities each broker may trade (BR-B19).
  final Map<String, Set<String>> brokerSecurities;
  final TradeLimits limits;

  final DateTime Function() _clock;
  final List<BrokerOrder> _orders; // newest first
  final List<BrokerTrade> _trades; // newest first
  final List<DeskEvent> _events = [];
  final Map<String, Map<String, int>> _holdings;
  final Map<String, String> _pins; // TODO(backend): hashed, set in Profile
  final Map<String, OrderMeta> _meta = {};
  final Map<String, String> _requests = {}; // requestId -> order number
  final Map<String, _Approval> _approvals = {};
  final Map<String, _PinState> _pinStates = {};
  final Map<String, List<DateTime>> _recent = {};
  int _seq = 0;

  /// The demo book: the same orders and trades the broker app used to keep on
  /// its own, plus accounts, securities, holdings and a demo PIN (`1234`).
  factory TradeDesk.demo({DateTime Function()? clock}) {
    return TradeDesk(
      clock: clock,
      orders: const [
        BrokerOrder(orderNumber: '1042', clientId: 'C001', symbol: 'ABCD', action: 'Buy', quantity: 50, price: 512.00, status: OrderStatus.pending, date: '08 Oct'),
        BrokerOrder(orderNumber: '1041', clientId: 'C002', symbol: 'EFGH', action: 'Sell', quantity: 120, price: 298.40, status: OrderStatus.executed, date: '07 Oct'),
        BrokerOrder(orderNumber: '1040', clientId: 'C001', symbol: 'IJKL', action: 'Buy', quantity: 30, price: 905.10, status: OrderStatus.partial, date: '07 Oct'),
        BrokerOrder(orderNumber: '1039', clientId: 'C003', symbol: 'MNOP', action: 'Buy', quantity: 200, price: 221.00, status: OrderStatus.cancelled, date: '06 Oct'),
        BrokerOrder(orderNumber: '1038', clientId: 'C005', symbol: 'ABCD', action: 'Sell', quantity: 10, price: 512.00, status: OrderStatus.pending, date: '06 Oct'),
        BrokerOrder(orderNumber: '1037', clientId: 'C002', symbol: 'IJKL', action: 'Buy', quantity: 15, price: 905.10, status: OrderStatus.executed, date: '06 Oct'),
        BrokerOrder(orderNumber: '1036', clientId: 'C004', symbol: 'IJKL', action: 'Sell', quantity: 5, price: 905.10, status: OrderStatus.pending, date: '05 Oct'),
        BrokerOrder(orderNumber: '1035', clientId: 'C003', symbol: 'MNOP', action: 'Buy', quantity: 200, price: 221.00, status: OrderStatus.executed, date: '05 Oct'),
        BrokerOrder(orderNumber: '1034', clientId: 'C005', symbol: 'ABCD', action: 'Buy', quantity: 40, price: 510.00, status: OrderStatus.executed, date: '04 Oct'),
        BrokerOrder(orderNumber: '1033', clientId: 'C001', symbol: 'EFGH', action: 'Sell', quantity: 20, price: 301.00, status: OrderStatus.executed, date: '03 Oct'),
        // Another broker's order.
        BrokerOrder(orderNumber: '1030', clientId: 'C900', symbol: 'ABCD', action: 'Buy', quantity: 5, price: 512.00, status: OrderStatus.pending, date: '02 Oct'),
      ],
      trades: const [
        BrokerTrade(tradeNumber: 'T-501', orderNumber: '1041', clientId: 'C002', symbol: 'EFGH', quantity: 120, price: 298.40, status: OrderStatus.executed, date: '07 Oct'),
        BrokerTrade(tradeNumber: 'T-500', orderNumber: '1040', clientId: 'C001', symbol: 'IJKL', quantity: 10, price: 905.10, status: OrderStatus.partial, date: '07 Oct'),
        BrokerTrade(tradeNumber: 'T-499', orderNumber: '1037', clientId: 'C002', symbol: 'IJKL', quantity: 15, price: 905.10, status: OrderStatus.executed, date: '07 Oct'),
        BrokerTrade(tradeNumber: 'T-498', orderNumber: '1035', clientId: 'C003', symbol: 'MNOP', quantity: 200, price: 221.00, status: OrderStatus.executed, date: '06 Oct'),
        BrokerTrade(tradeNumber: 'T-497', orderNumber: '1034', clientId: 'C005', symbol: 'ABCD', quantity: 40, price: 510.00, status: OrderStatus.executed, date: '06 Oct'),
        BrokerTrade(tradeNumber: 'T-496', orderNumber: '1033', clientId: 'C001', symbol: 'EFGH', quantity: 20, price: 301.00, status: OrderStatus.executed, date: '05 Oct'),
      ],
      accounts: const {
        'C001': [
          DeskAccount(accountNumber: 'A001', brokerCode: 'B001', brokerName: 'Broker name', isActive: true),
          DeskAccount(accountNumber: 'A002', brokerCode: 'B002', brokerName: 'Second broker name', isActive: true),
          DeskAccount(accountNumber: 'A003', brokerCode: 'B001', brokerName: 'Broker name', isActive: false),
        ],
      },
      securities: const {
        'ABCD': DeskSecurity(symbol: 'ABCD', lastClose: 512.00),
        'EFGH': DeskSecurity(symbol: 'EFGH', lastClose: 298.40),
        'IJKL': DeskSecurity(symbol: 'IJKL', lastClose: 905.10),
        'MNOP': DeskSecurity(symbol: 'MNOP', lastClose: 221.00, isActive: false),
        'QRST': DeskSecurity(symbol: 'QRST', lastClose: 149.80, isActive: false),
      },
      holdings: const {
        'C001': {'ABCD': 50, 'EFGH': 120, 'IJKL': 30, 'MNOP': 200},
        'C002': {'EFGH': 80, 'IJKL': 15},
        'C003': {'MNOP': 150, 'ABCD': 25, 'QRST': 100},
        'C005': {'ABCD': 40},
        'C006': {'IJKL': 10, 'EFGH': 60, 'MNOP': 40, 'ABCD': 12, 'QRST': 30},
      },
      brokerSecurities: const {
        'B001': {'ABCD', 'EFGH', 'IJKL', 'MNOP', 'QRST'},
        'B002': {'ABCD'},
      },
      pins: const {'C001': '1234'},
    );
  }

  // ---- reads (every one is scoped; there is no "all orders" for a client) --

  List<BrokerOrder> get orders => List.unmodifiable(_orders);
  List<BrokerTrade> get trades => List.unmodifiable(_trades);
  List<DeskEvent> get events => List.unmodifiable(_events);

  List<DeskAccount> accountsOf(String clientId) =>
      accounts[clientId] ?? const [];

  DeskSecurity? security(String symbol) => securities[symbol];

  bool isTradable(String symbol) => securities[symbol]?.isActive ?? false;

  /// BR-I27: an investor sees only orders of their own accounts.
  List<BrokerOrder> ordersOf(String clientId) =>
      _orders.where((o) => o.clientId == clientId).toList();

  List<BrokerTrade> tradesOf(String clientId) =>
      _trades.where((t) => t.clientId == clientId).toList();

  OrderMeta? metaOf(String orderNumber) => _meta[orderNumber];

  /// Orders without a recorded account (the seed data) reach any broker that
  /// is assigned to the investor; new orders reach only the account's broker.
  bool routedTo(BrokerOrder order, String brokerCode) {
    final meta = _meta[order.orderNumber];
    return meta == null || meta.brokerCode == brokerCode;
  }

  /// BR-I06: one holding per security.
  Map<String, int> holdingsOf(String clientId) =>
      Map.unmodifiable(_holdings[clientId] ?? const {});

  int heldUnits(String clientId, String symbol) =>
      _holdings[clientId]?[symbol] ?? 0;

  /// Units already promised to open sell orders.
  int reservedForSale(String clientId, String symbol) {
    var reserved = 0;
    for (final o in _orders) {
      if (o.clientId == clientId &&
          o.symbol == symbol &&
          !o.isBuy &&
          o.status.isOpen) {
        reserved += o.quantity - _filled(o.orderNumber);
      }
    }
    return reserved;
  }

  /// What the investor may still put into a new sell order.
  int sellableUnits(String clientId, String symbol) {
    final free = heldUnits(clientId, symbol) - reservedForSale(clientId, symbol);
    return free < 0 ? 0 : free;
  }

  int openOrderCount(String clientId) =>
      _orders.where((o) => o.clientId == clientId && o.status.isOpen).length;

  int _filled(String orderNumber) => _trades
      .where((t) => t.orderNumber == orderNumber)
      .fold<int>(0, (sum, t) => sum + t.quantity);

  // ---- step 1: approval (PIN) ---------------------------------------------

  /// What a PIN approval is bound to, so approving 5 units cannot be reused
  /// to send 5,000.
  static String fingerprint({
    required String accountNumber,
    required String symbol,
    required String action,
    required int quantity,
    required double pricePerUnit,
  }) =>
      '$accountNumber|$symbol|${action.toLowerCase()}|$quantity|'
      '${pricePerUnit.toStringAsFixed(2)}';

  /// Checks the investor's trade PIN. After [TradeLimits.maxPinAttempts]
  /// wrong tries the investor is locked out for [TradeLimits.pinLockout].
  /// On success returns a short-lived, single-use approval for this order.
  PinResult verifyPin({
    required String clientId,
    required String pin,
    required String fingerprint,
  }) {
    final now = _clock();
    final state = _pinStates.putIfAbsent(clientId, _PinState.new);

    final until = state.lockedUntil;
    if (until != null) {
      if (now.isBefore(until)) return PinResult.locked(until);
      state
        ..lockedUntil = null
        ..failures = 0;
    }

    if (_pins[clientId] != null && _pins[clientId] == pin) {
      state.failures = 0;
      final token =
          'AUTH-${_seq++}-${Object.hash(clientId, fingerprint, now.microsecondsSinceEpoch).toRadixString(36)}';
      _approvals[token] = _Approval(
        clientId: clientId,
        fingerprint: fingerprint,
        expires: now.add(limits.authorizationTtl),
      );
      return PinResult.approved(token);
    }

    state.failures++;
    if (state.failures >= limits.maxPinAttempts) {
      state.lockedUntil = now.add(limits.pinLockout);
      _log(clientId, 'PIN locked',
          'Too many wrong trade PIN attempts. Locked for '
          '${limits.pinLockout.inMinutes} minutes.');
      notifyListeners();
      return PinResult.locked(state.lockedUntil!);
    }
    return PinResult.wrong(limits.maxPinAttempts - state.failures);
  }

  // ---- step 2: submit ------------------------------------------------------

  /// Creates an order *request*. [clientId] comes from the signed-in session,
  /// never from the screen (BR-08, BR-S03). The order is always created as
  /// Pending: the investor cannot execute anything.
  SubmitResult submit({
    required String clientId,
    required OrderRequest request,
  }) {
    // Same request again (double tap, retry): hand back the first result.
    final earlier = _requests[request.requestId];
    if (earlier != null) {
      final order = _orders.firstWhere((o) => o.orderNumber == earlier);
      if (order.clientId == clientId) return SubmitResult.repeat(order);
    }

    // Gate 1: the approval must be this investor's, for exactly this order,
    // unexpired and unused. It is spent whatever happens next.
    final fp = fingerprint(
      accountNumber: request.accountNumber,
      symbol: request.symbol,
      action: request.action,
      quantity: request.quantity,
      pricePerUnit: request.pricePerUnit,
    );
    final approval = _approvals.remove(request.authorization);
    final now = _clock();
    if (approval == null ||
        approval.clientId != clientId ||
        approval.fingerprint != fp ||
        now.isAfter(approval.expires)) {
      return const SubmitResult.refused(TradeRefusal.authorizationRequired);
    }

    // Gate 2: the account must be one of this investor's.
    DeskAccount? account;
    for (final a in accountsOf(clientId)) {
      if (a.accountNumber == request.accountNumber) account = a;
    }
    if (account == null) {
      return const SubmitResult.refused(TradeRefusal.accountNotOwned);
    }

    // Gate 3: flood control.
    final recent = (_recent[clientId] ??= [])
      ..removeWhere((t) => now.difference(t) > limits.window);
    if (recent.length >= limits.maxOrdersPerWindow) {
      return const SubmitResult.refused(TradeRefusal.rateLimited);
    }

    // Business validation (BR-I25). Failures are kept as Rejected orders.
    final refusal = _validate(clientId, account, request);
    recent.add(now);
    final number = '${_nextOrderNumber()}';
    final order = BrokerOrder(
      orderNumber: number,
      clientId: clientId,
      symbol: request.symbol,
      action: request.isBuy ? 'Buy' : 'Sell',
      quantity: request.quantity,
      price: request.pricePerUnit,
      status: refusal == null ? OrderStatus.pending : OrderStatus.rejected,
      date: _today(),
    );
    _orders.insert(0, order);
    _requests[request.requestId] = number;
    _meta[number] = OrderMeta(
      accountNumber: account.accountNumber,
      brokerCode: account.brokerCode,
      createdAt: _stamp(),
      reason: refusal?.message,
    );
    _log(
      clientId,
      refusal == null ? 'Order placed' : 'Order refused',
      refusal == null
          ? '${order.action} order #$number for ${order.quantity} units of '
              '${order.symbol} is waiting for your approval'
          : '${order.action} order #$number for ${order.symbol} was refused: '
              '${refusal.message}',
    );
    notifyListeners();
    return refusal == null
        ? SubmitResult.accepted(order)
        : SubmitResult.refused(refusal, order: order);
  }

  TradeRefusal? _validate(
    String clientId,
    DeskAccount account,
    OrderRequest r,
  ) {
    if (!account.isActive) return TradeRefusal.accountInactive; // BR-B12
    final security = securities[r.symbol];
    if (security == null || !security.isActive) {
      return TradeRefusal.securityUnavailable; // BR-07
    }
    if (!(brokerSecurities[account.brokerCode]?.contains(r.symbol) ?? false)) {
      return TradeRefusal.securityNotCovered; // BR-B19
    }
    if (r.quantity <= 0) return TradeRefusal.invalidQuantity; // BR-I21
    if (!(r.pricePerUnit > 0) || r.pricePerUnit.isNaN || r.pricePerUnit.isInfinite) {
      return TradeRefusal.invalidPrice; // BR-I22
    }
    if (r.quantity > limits.maxQuantityPerOrder) {
      return TradeRefusal.quantityLimit;
    }
    if (r.quantity * r.pricePerUnit > limits.maxOrderValue) {
      return TradeRefusal.valueLimit;
    }
    final band = security.lastClose * limits.priceBandPercent / 100;
    if ((r.pricePerUnit - security.lastClose).abs() > band) {
      return TradeRefusal.priceOutsideBand;
    }
    if (!r.isBuy && r.quantity > sellableUnits(clientId, r.symbol)) {
      return TradeRefusal.insufficientHoldings;
    }
    if (openOrderCount(clientId) >= limits.maxOpenOrders) {
      return TradeRefusal.tooManyOpenOrders;
    }
    return null;
  }

  // ---- investor: cancel ----------------------------------------------------

  /// BR-I29: only the investor's own order, and only while Pending or
  /// Submitted. Anything else is refused and left untouched.
  CancelResult cancel({required String clientId, required String orderNumber}) {
    final index = _orders.indexWhere((o) => o.orderNumber == orderNumber);
    if (index < 0 || _orders[index].clientId != clientId) {
      return const CancelResult(cancelled: false, order: null); // BR-S04
    }
    final order = _orders[index];
    final canCancel = order.status == OrderStatus.pending ||
        order.status == OrderStatus.submitted;
    if (!canCancel) return CancelResult(cancelled: false, order: order);

    final updated = order.copyWith(status: OrderStatus.cancelled);
    _orders[index] = updated;
    _log(clientId, 'Order cancelled',
        'Order #${order.orderNumber} for ${order.symbol} was cancelled by '
        'the investor');
    notifyListeners();
    return CancelResult(cancelled: true, order: updated);
  }

  // ---- broker: decide ------------------------------------------------------

  /// The only way an order moves past Pending. The broker repository calls it
  /// after checking that the order belongs to one of the broker's investors.
  BrokerOrder applyBrokerStatus(String orderNumber, OrderStatus next) {
    final index = _orders.indexWhere((o) => o.orderNumber == orderNumber);
    if (index < 0) throw const TradeDeskError('That order no longer exists.');
    final order = _orders[index];

    if (!order.status.nextStatuses.contains(next)) {
      throw TradeDeskError(
        "A ${order.status.label.toLowerCase()} order can't be changed to "
        '${next.label.toLowerCase()}.',
      );
    }

    final fills = next == OrderStatus.executed || next == OrderStatus.partial;
    if (fills) {
      final remaining = order.quantity - _filled(order.orderNumber);
      if (!order.isBuy && remaining > heldUnits(order.clientId, order.symbol)) {
        throw const TradeDeskError(
          'The investor no longer holds enough units to execute this sell '
          'order.',
        );
      }
    }

    final updated = order.copyWith(status: next);
    _orders[index] = updated;
    if (fills) _recordTrade(updated, next);
    notifyListeners();
    return updated;
  }

  /// One order can produce several trades (BR-I31). Executing one is also the
  /// only thing that changes holdings (BR-I09).
  void _recordTrade(BrokerOrder order, OrderStatus status) {
    final remaining = order.quantity - _filled(order.orderNumber);
    if (remaining <= 0) return;
    final qty = status == OrderStatus.executed
        ? remaining
        : (remaining ~/ 2 < 1 ? 1 : remaining ~/ 2);
    final lastNumber = _trades.isEmpty
        ? 500
        : int.parse(_trades.first.tradeNumber.substring(2));
    _trades.insert(
      0,
      BrokerTrade(
        tradeNumber: 'T-${lastNumber + 1}',
        orderNumber: order.orderNumber,
        clientId: order.clientId,
        symbol: order.symbol,
        quantity: qty,
        price: order.price,
        status: status,
        date: _today(),
      ),
    );

    final book = _holdings.putIfAbsent(order.clientId, () => {});
    final held = book[order.symbol] ?? 0;
    final next = order.isBuy ? held + qty : held - qty;
    if (next <= 0) {
      book.remove(order.symbol);
    } else {
      book[order.symbol] = next;
    }
  }

  // ---- helpers -------------------------------------------------------------

  int _nextOrderNumber() {
    var highest = 1042;
    for (final o in _orders) {
      final n = int.tryParse(o.orderNumber);
      if (n != null && n > highest) highest = n;
    }
    return highest + 1;
  }

  void _log(String clientId, String action, String details) {
    _events.insert(
      0,
      DeskEvent(
        time: 'Just now',
        action: action,
        clientId: clientId,
        details: details,
      ),
    );
  }

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _today() {
    final d = _clock();
    return '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]}';
  }

  String _stamp() {
    final d = _clock();
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${_today()}, $hh:$mm';
  }
}

class _Approval {
  _Approval({
    required this.clientId,
    required this.fingerprint,
    required this.expires,
  });

  final String clientId;
  final String fingerprint;
  final DateTime expires;
}

class _PinState {
  int failures = 0;
  DateTime? lockedUntil;
}
