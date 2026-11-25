import 'package:flutter/material.dart';
import 'package:trading_management_system/core/widgets/widgets.dart';
import 'package:trading_management_system/features/auth/auth_session.dart';

import 'investor/dashboard/investor_dashboard_screen.dart';
import 'investor/ipo/investor_ipo_apply_screen.dart';
import 'investor/ipo/investor_ipo_screen.dart';
import 'investor/market/investor_market_screen.dart';
import 'investor/more/investor_more_screen.dart';
import 'investor/notifications/investor_notifications_screen.dart';
import 'investor/portfolio/investor_portfolio_screen.dart';
import 'investor/profile/investor_profile_screen.dart';
import 'investor/security/investor_security_screen.dart';
import 'investor/trades/accounts/trade_accounts_screen.dart';
import 'investor/trades/confirm/trade_confirm_screen.dart';
import 'investor/trades/dashboard/trade_dashboard_screen.dart';
import 'investor/trades/investor_trades_screen.dart';
import 'investor/trades/order/trade_order_screen.dart';
import 'investor/trades/orders/trade_orders_screen.dart';
import 'investor/trades/review/trade_review_screen.dart';
import 'investor/trades/security/trade_security_screen.dart';
import 'investor/trades/select/trade_select_screen.dart';
import 'investor/trades/sell/trade_sell_screen.dart';
import 'investor/trades/state/account_inactive_state.dart';
import 'investor/trades/state/cancel_order_state.dart';
import 'investor/trades/state/empty_orders_state.dart';
import 'investor/trades/state/no_account_state.dart';
import 'investor/trades/state/order_rejected_state.dart';
import 'investor/trades/state/security_unavailable_state.dart';
import 'investor/trades/status/trade_status_screen.dart';
import 'investor/transactions/investor_transactions_screen.dart';
import 'state/error_state.dart';
import 'state/ipo_applied_state.dart';
import 'state/ipo_closed_state.dart';
import 'state/loading_state.dart';
import 'state/stale_data_state.dart';

/// What the Market tab simulates, so every data state can be seen (BR-M08).
enum MarketFeed { available, failed, stale }

/// The whole investor journey, in one place.
///
/// ```
/// Bottom tabs (replace each other)
///   Home ─┬─ explore tiles ─► Orders · Trades · Transactions · IPO ·
///         │                    Notifications · Profile
///   Portfolio ─► Security detail                         (BR-I05..I10)
///   Market ─► Security detail            (loading / error / stale, BR-I15)
///   Trade ─► guards: no account / inactive account       (BR-07, BR-B12)
///        ├─ Buy ─► Select ─► Security ─► Order ─► Review ─► Confirm
///        ├─ Sell ─► Held securities ─► Sell ─► Review ─► Confirm
///        │             └─ validation fails ─► Order rejected    (BR-I25)
///        ├─ Switch account                                      (BR-B10)
///        └─ Orders ─► Status ─► Cancel only if Pending          (BR-I29)
///   More ─► same pages as Home + Sign out
///
/// IPO list ─► Apply (open, within min/max, one per IPO)  (BR-I39..I41)
///          ├─ already applied ─► Applied state
///          └─ not open ─► Closed state
/// ```
///
/// Everything here is in-memory demo data. The backend must derive the
/// investor from the auth token (BR-08, BR-S03); no screen takes an
/// investor id from the client.
class InvestorFlow extends StatefulWidget {
  const InvestorFlow({
    super.key,
    required this.session,
    required this.onSignOut,
    this.accounts = demoAccounts,
    this.marketFeed = MarketFeed.available,
  });

  final AuthSession session;
  final VoidCallback onSignOut;

  /// Trading accounts of this investor. Pass `[]` to see the no-account state.
  final List<TradeAccount> accounts;

  final MarketFeed marketFeed;

  static const List<TradeAccount> demoAccounts = [
    TradeAccount(accountNumber: 'A001', brokerName: 'Broker name', isActive: true),
    TradeAccount(accountNumber: 'A002', brokerName: 'Second broker name', isActive: true),
    TradeAccount(accountNumber: 'A003', brokerName: 'Broker name', isActive: false),
  ];

  @override
  State<InvestorFlow> createState() => _InvestorFlowState();
}

class _Ipo {
  const _Ipo(this.name, this.price, this.min, this.max, this.closing, this.open);

  final String name;
  final double price;
  final int min;
  final int max;
  final String closing;
  final bool open;
}

class _InvestorFlowState extends State<InvestorFlow> {
  // ---- demo data (replace with API calls) ---------------------------------

  static const List<TradeSecurity> _catalog = [
    TradeSecurity(symbol: 'ABCD', companyName: 'Sample Bank Ltd', sector: 'Banks', price: 512.00, changePercent: 1.2, closeDate: '08 Oct'),
    TradeSecurity(symbol: 'EFGH', companyName: 'Sample Hydropower Ltd', sector: 'Hydropower', price: 298.40, changePercent: -0.8, closeDate: '08 Oct'),
    TradeSecurity(symbol: 'IJKL', companyName: 'Sample Insurance Ltd', sector: 'Insurance', price: 905.10, changePercent: 2.1, closeDate: '08 Oct'),
    TradeSecurity(symbol: 'MNOP', companyName: 'Sample Finance Ltd', sector: 'Finance', price: 221.00, changePercent: -0.3, closeDate: '08 Oct'),
  ];

  /// Inactive securities cannot be traded (BR-07).
  static const Set<String> _inactiveSymbols = {'MNOP'};

  /// Current holdings: investor + security = one holding (BR-I06).
  static const Map<String, int> _held = {'ABCD': 50, 'EFGH': 120, 'IJKL': 30, 'MNOP': 200};

  static const Map<String, _Ipo> _ipos = {
    'ABCD': _Ipo('Sample Bank IPO', 100, 10, 100, '16 Oct', true),
    'EFGH': _Ipo('Sample Hydropower IPO', 100, 10, 100, '29 Oct', false),
  };

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  // ---- state --------------------------------------------------------------

  final GlobalKey<NavigatorState> _nav = GlobalKey<NavigatorState>();
  late final _RouteObserver _observer = _RouteObserver(_syncCanPop);
  final ValueNotifier<bool> _canPop = ValueNotifier<bool>(false);

  late TradeAccount? _account = _initialAccount();
  int _nextOrderNumber = 1043;

  /// Orders of this investor's own accounts only (BR-I27).
  final List<TradeOrderRecord> _orders = [
    const TradeOrderRecord(orderNumber: '1042', symbol: 'ABCD', action: 'Buy', status: 'Pending', quantity: 50, pricePerUnit: 512.00, date: '08 Oct'),
    const TradeOrderRecord(orderNumber: '1041', symbol: 'EFGH', action: 'Sell', status: 'Executed', quantity: 120, pricePerUnit: 298.40, date: '07 Oct'),
    const TradeOrderRecord(orderNumber: '1040', symbol: 'IJKL', action: 'Buy', status: 'Executed', quantity: 30, pricePerUnit: 905.10, date: '07 Oct'),
    const TradeOrderRecord(orderNumber: '1039', symbol: 'MNOP', action: 'Buy', status: 'Cancelled', quantity: 200, pricePerUnit: 221.00, date: '06 Oct'),
  ];

  /// One application per IPO (BR-I41): symbol -> units requested.
  final Map<String, int> _ipoApplications = {};

  TradeAccount? _initialAccount() {
    if (widget.accounts.isEmpty) return null;
    return widget.accounts.firstWhere(
      (a) => a.isActive,
      orElse: () => widget.accounts.first,
    );
  }

  AuthSession get _user => widget.session;
  String get _clientId => _user.clientId ?? 'C001';

  @override
  void dispose() {
    _canPop.dispose();
    super.dispose();
  }

  // ---- navigation helpers -------------------------------------------------

  NavigatorState get _n => _nav.currentState!;

  void _syncCanPop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _canPop.value = _nav.currentState?.canPop() ?? false;
    });
  }

  Route<void> _fade(Widget page) => PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 180),
        reverseTransitionDuration: const Duration(milliseconds: 120),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      );

  Route<void> _slide(Widget page) =>
      MaterialPageRoute<void>(builder: (_) => page);

  void _push(Widget page) => _n.push(_slide(page));
  void _pop() => _n.maybePop();

  /// Bottom-tab switch: the tab becomes the only route, so Back never walks
  /// through earlier tabs. Index order matches [InvestorTab].
  void _goTab(int index) =>
      _n.pushAndRemoveUntil(_fade(_tab(index)), (_) => false);

  /// Drops every sub-page above the current tab, then opens [page].
  void _resetTo(Widget page) {
    _n.popUntil((r) => r.isFirst);
    _push(page);
  }

  void _toast(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  void _contactBroker() => _toast(
        'Contact ${_account?.brokerName ?? 'your broker'} for help with this.',
      );

  String _today() {
    final d = DateTime.now();
    return '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]}';
  }

  String _now() {
    final d = DateTime.now();
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${_today()}, $hh:$mm';
  }

  TradeSecurity _find(String symbol) => _catalog.firstWhere(
        (s) => s.symbol == symbol,
        orElse: () => _catalog.first,
      );

  bool _isBuy(String action) => action.toLowerCase() == 'buy';

  // ---- build --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _canPop,
      // Inside the flow Back pops sub-pages; at a tab root it leaves the app.
      builder: (context, canPop, child) => NavigatorPopHandler(
        enabled: canPop,
        onPop: () => _nav.currentState?.maybePop(),
        child: child!,
      ),
      child: Navigator(
        key: _nav,
        observers: [_observer],
        onGenerateRoute: (_) => _fade(_tab(0)),
      ),
    );
  }

  // ---- tabs ---------------------------------------------------------------

  Widget _tab(int index) {
    switch (InvestorTab.values[index]) {
      case InvestorTab.home:
        return _homeTab();
      case InvestorTab.portfolio:
        return _portfolioTab();
      case InvestorTab.market:
        return _MarketTab(
          feed: widget.marketFeed,
          securities: _catalog,
          onSecuritySelected: (s) => _push(_securityDetail(s)),
          onDestinationSelected: _goTab,
        );
      case InvestorTab.trade:
        return _tradeTab();
      case InvestorTab.more:
        return InvestorMoreScreen(
          investorName: _user.displayName,
          clientId: _clientId,
          onDestinationSelected: (label) {
            if (label.startsWith('NAV:')) {
              _goTab(int.parse(label.substring(4)));
            } else {
              _openExplore(label);
            }
          },
          onSignOut: widget.onSignOut,
        );
    }
  }

  Widget _homeTab() => InvestorDashboardScreen(
        investorName: _user.displayName,
        onDestinationSelected: _goTab,
        onExploreSelected: _openExplore,
      );

  Widget _portfolioTab() => InvestorPortfolioScreen(
        onDestinationSelected: _goTab,
        onSecuritySelected: (symbol) => _push(_securityDetail(_find(symbol))),
      );

  /// Home tiles and the More menu both land here.
  void _openExplore(String destination) {
    switch (destination) {
      case 'Orders':
        _push(_ordersScreen());
      case 'Trades':
        _push(InvestorTradesScreen(onBack: _pop, onDestinationSelected: _goTab));
      case 'Transactions':
        _push(InvestorTransactionsScreen(onBack: _pop, onDestinationSelected: _goTab));
      case 'IPO':
        _push(_ipoScreen());
      case 'Notifications':
        _push(_notificationsScreen());
      case 'Profile':
        _push(_profileScreen());
    }
  }

  // ---- market / security --------------------------------------------------

  Widget _securityDetail(TradeSecurity s) => InvestorSecurityScreen(
        symbol: s.symbol,
        companyName: s.companyName,
        sector: s.sector,
        price: s.price,
        changePercent: s.changePercent,
        closeDate: s.closeDate,
        // TODO: real open/high/low/volume come from MarketData (BR-I16).
        open: s.price * (1 - s.changePercent / 200),
        high: s.price * 1.01,
        low: s.price * 0.99,
        volume: 12400,
        onBack: _pop,
        onDestinationSelected: _goTab,
      );

  // ---- notifications / profile --------------------------------------------

  Widget _notificationsScreen() => InvestorNotificationsScreen(
        onBack: _pop,
        onDestinationSelected: _goTab,
        // Notification types: ORDER, TRADE, IPO, TRANSACTION, SYSTEM (BR-I48).
        onNotificationSelected: (title) {
          final t = title.toLowerCase();
          if (t.contains('order')) {
            _push(_ordersScreen());
          } else if (t.contains('trade')) {
            _openExplore('Trades');
          } else if (t.contains('ipo')) {
            _push(_ipoScreen());
          } else if (t.contains('transaction')) {
            _openExplore('Transactions');
          }
        },
      );

  Widget _profileScreen() => InvestorProfileScreen(
        investorName: _user.displayName,
        clientId: _clientId,
        username: _user.username,
        brokerName: _account?.brokerName ?? 'No broker assigned',
        tradingAccount: _account?.accountNumber ?? '-',
        onBack: _pop,
        onDestinationSelected: _goTab,
        onChangePassword: () => _toast('Change password will use the backend.'),
        onNotificationSettings: () => _toast('Notification settings come later.'),
        onContactBroker: _contactBroker,
        onSignOut: widget.onSignOut,
      );

  // ---- trade tab ----------------------------------------------------------

  Widget _tradeTab() {
    final account = _account;

    // BR-B10: trading needs an account.
    if (account == null) {
      return NoAccountState(
        onContactBroker: _contactBroker,
        onDestinationSelected: _goTab,
      );
    }
    // BR-B12: only an active trading account can trade.
    if (!account.isActive) {
      return _inactiveAccountState(account);
    }

    return TradeDashboardScreen(
      accountNumber: account.accountNumber,
      brokerName: account.brokerName,
      accountStatus: 'Active',
      onBuy: _startBuy,
      onSell: _startSell,
      onSwitchAccount: _openAccounts,
      onViewAllOrders: () => _push(_ordersScreen()),
      onSecuritySelected: (symbol) => _openTradeSecurity(_find(symbol)),
      onDestinationSelected: _goTab,
    );
  }

  Widget _inactiveAccountState(TradeAccount account) => AccountInactiveState(
        accountNumber: account.accountNumber,
        brokerName: account.brokerName,
        onContactBroker: _contactBroker,
        onViewPortfolio: () => _goTab(InvestorTab.portfolio.index),
        onDestinationSelected: _goTab,
      );

  void _openAccounts() {
    _push(TradeAccountsScreen(
      accounts: widget.accounts,
      selectedAccount: _account?.accountNumber ?? '',
      onClose: _pop,
      onAccountSelected: (account) {
        if (!account.isActive) {
          // Keep the current account; explain why this one can't be used.
          _push(_inactiveAccountState(account));
          return;
        }
        setState(() => _account = account);
        _goTab(InvestorTab.trade.index);
      },
    ));
  }

  // ---- buy ----------------------------------------------------------------

  void _startBuy() {
    _push(TradeSelectScreen(
      securities: _catalog,
      onBack: _pop,
      onSecuritySelected: _openTradeSecurity,
      onDestinationSelected: _goTab,
    ));
  }

  void _openTradeSecurity(TradeSecurity s) {
    final account = _account;
    if (account == null) return;

    // BR-07: inactive securities cannot be traded.
    if (_inactiveSymbols.contains(s.symbol)) {
      _push(SecurityUnavailableState(
        symbol: s.symbol,
        companyName: s.companyName,
        accountStatus: account.isActive ? 'Active' : 'Inactive',
        onBack: _pop,
        onChooseAnotherSecurity: _pop,
        onContactBroker: _contactBroker,
        onDestinationSelected: _goTab,
      ));
      return;
    }

    _push(TradeSecurityScreen(
      symbol: s.symbol,
      companyName: s.companyName,
      sector: s.sector,
      price: s.price,
      changePercent: s.changePercent,
      closeDate: s.closeDate,
      open: s.price * (1 - s.changePercent / 200),
      high: s.price * 1.01,
      low: s.price * 0.99,
      volume: 12400,
      accountNumber: account.accountNumber,
      accountStatus: account.isActive ? 'Active' : 'Inactive',
      onBack: _pop,
      onTrade: () => _openOrder(s, 'Buy'),
      onDestinationSelected: _goTab,
    ));
  }

  void _openOrder(TradeSecurity s, String action) {
    _push(TradeOrderScreen(
      symbol: s.symbol,
      companyName: s.companyName,
      pricePerUnit: s.price,
      lastCloseDate: s.closeDate,
      initialAction: action,
      onBack: _pop,
      onReviewOrder: _review,
      onDestinationSelected: _goTab,
    ));
  }

  // ---- sell ---------------------------------------------------------------

  void _startSell() {
    // You can only sell what you hold.
    final holdings = _catalog.where((s) => (_held[s.symbol] ?? 0) > 0).toList();

    _push(TradeSelectScreen(
      securities: holdings,
      onBack: _pop,
      onSecuritySelected: _openSell,
      onDestinationSelected: _goTab,
    ));
  }

  void _openSell(TradeSecurity s) {
    final account = _account;
    if (account == null) return;

    if (_inactiveSymbols.contains(s.symbol)) {
      _openTradeSecurity(s); // shows the unavailable state
      return;
    }

    _push(TradeSellScreen(
      symbol: s.symbol,
      companyName: s.companyName,
      pricePerUnit: s.price,
      closeDate: s.closeDate,
      heldUnits: _held[s.symbol] ?? 0,
      initialQuantity: 1,
      accountNumber: account.accountNumber,
      onBack: _pop,
      onBuySelected: () => _openOrder(s, 'Buy'),
      onReviewOrder: (quantity) => _review(TradeOrderDraft(
        symbol: s.symbol,
        companyName: s.companyName,
        action: 'Sell',
        quantity: quantity,
        pricePerUnit: s.price,
      )),
      onDestinationSelected: _goTab,
    ));
  }

  // ---- review -> confirm --------------------------------------------------

  void _review(TradeOrderDraft draft) {
    final account = _account;
    if (account == null) return;

    // BR-I26: the investor reviews the important details before confirming.
    _push(TradeReviewScreen(
      symbol: draft.symbol,
      companyName: draft.companyName,
      action: draft.action,
      quantity: draft.quantity,
      pricePerUnit: draft.pricePerUnit,
      accountNumber: account.accountNumber,
      onBack: _pop,
      onEditDetails: _pop,
      onConfirmOrder: () => _placeOrder(draft),
      onDestinationSelected: _goTab,
    ));
  }

  /// BR-I25: business validation before the order proceeds.
  bool _passesValidation(TradeOrderDraft d) {
    final account = _account;
    if (account == null || !account.isActive) return false; // BR-B12
    if (_inactiveSymbols.contains(d.symbol)) return false; // BR-07
    if (d.quantity <= 0 || d.pricePerUnit <= 0) return false; // BR-I21, I22
    if (!_isBuy(d.action) && d.quantity > (_held[d.symbol] ?? 0)) {
      return false; // cannot sell more than is held
    }
    return true;
  }

  void _placeOrder(TradeOrderDraft draft) {
    final isBuy = _isBuy(draft.action);
    final accepted = _passesValidation(draft);
    final number = '${_nextOrderNumber++}';

    final record = TradeOrderRecord(
      orderNumber: number,
      symbol: draft.symbol,
      action: isBuy ? 'Buy' : 'Sell',
      status: accepted ? 'Pending' : 'Rejected',
      quantity: draft.quantity,
      pricePerUnit: draft.pricePerUnit,
      date: _today(),
    );
    setState(() => _orders.insert(0, record));

    // Replace review/order pages so Back can't submit the same order twice.
    final Widget result = accepted
        ? TradeConfirmScreen(
            orderNumber: number,
            symbol: draft.symbol,
            action: isBuy ? 'Buy' : 'Sell',
            quantity: draft.quantity,
            status: 'Pending',
            // Replaces the confirm page, so Back from status goes to the tab.
            onViewOrderStatus: () =>
                _n.pushReplacement(_slide(_statusScreen(record))),
            onBackToMarket: () => _goTab(InvestorTab.market.index),
          )
        : OrderRejectedState(
            orderNumber: number,
            symbol: draft.symbol,
            isBuy: isBuy,
            quantity: draft.quantity,
            pricePerUnit: draft.pricePerUnit,
            submittedAt: _now(),
            onBack: () => _goTab(InvestorTab.trade.index),
            onPlaceNewOrder: () => _goTab(InvestorTab.trade.index),
            onContactBroker: _contactBroker,
            onDestinationSelected: _goTab,
          );

    _n.pushAndRemoveUntil(_slide(result), (r) => r.isFirst);
  }

  // ---- orders / status / cancel ------------------------------------------

  Widget _ordersScreen() {
    if (_orders.isEmpty) {
      return EmptyOrdersState(
        onBack: _pop,
        onPlaceOrder: () => _goTab(InvestorTab.trade.index),
        onDestinationSelected: _goTab,
      );
    }
    return TradeOrdersScreen(
      orders: List<TradeOrderRecord>.unmodifiable(_orders),
      onBack: _pop,
      onOrderSelected: _openStatus,
      onDestinationSelected: _goTab,
    );
  }

  void _openStatus(TradeOrderRecord order) => _push(_statusScreen(order));

  Widget _statusScreen(TradeOrderRecord order) => TradeStatusScreen(
      orderNumber: order.orderNumber,
      status: order.status,
      symbol: order.symbol,
      isBuy: _isBuy(order.action),
      quantity: order.quantity,
      pricePerUnit: order.pricePerUnit,
      submittedAt: order.date,
      onBack: _pop,
      onCancelOrder: () => _cancel(order),
      onDestinationSelected: _goTab,
    );

  /// BR-I29: cancellation only when the current status permits it.
  void _cancel(TradeOrderRecord order) {
    final index = _orders.indexWhere((o) => o.orderNumber == order.orderNumber);
    final current = index == -1 ? order : _orders[index];
    final canCancel = current.status == 'Pending' || current.status == 'Submitted';

    if (canCancel && index != -1) {
      setState(() {
        _orders[index] = TradeOrderRecord(
          orderNumber: current.orderNumber,
          symbol: current.symbol,
          action: current.action,
          status: 'Cancelled',
          quantity: current.quantity,
          pricePerUnit: current.pricePerUnit,
          date: current.date,
        );
      });
    }

    _n.pushReplacement(_slide(CancelOrderState(
      orderNumber: current.orderNumber,
      symbol: current.symbol,
      cancelled: canCancel,
      currentStatus: current.status,
      onBack: _pop,
      onViewOrders: () => _resetTo(_ordersScreen()),
      onDestinationSelected: _goTab,
    )));
  }

  // ---- IPO ----------------------------------------------------------------

  Widget _ipoScreen() => InvestorIpoScreen(
        onBack: _pop,
        onApply: _applyForIpo,
        onDestinationSelected: _goTab,
      );

  void _applyForIpo(String symbol) {
    final ipo = _ipos[symbol];
    if (ipo == null) return;

    // BR-I41: one application per IPO.
    if (_ipoApplications.containsKey(symbol)) {
      _push(_ipoApplied(symbol, ipo));
      return;
    }
    // BR-I39: only while the IPO is open.
    if (!ipo.open) {
      _push(IpoClosedState(
        companyName: ipo.name,
        closingDate: ipo.closing,
        onBack: _pop,
        onBackToIpos: _pop,
        onDestinationSelected: _goTab,
      ));
      return;
    }

    _push(InvestorIpoApplyScreen(
      companyName: ipo.name,
      symbol: symbol,
      pricePerUnit: ipo.price,
      minimumUnits: ipo.min,
      maximumUnits: ipo.max,
      closingDate: ipo.closing,
      onBack: _pop,
      onSubmit: (units) => _submitIpo(symbol, ipo, units),
      onDestinationSelected: _goTab,
    ));
  }

  void _submitIpo(String symbol, _Ipo ipo, int units) {
    // BR-I40: units must be within the IPO's minimum and maximum.
    if (units < ipo.min || units > ipo.max) {
      _toast('Units must be between ${ipo.min} and ${ipo.max}.');
      return;
    }
    setState(() => _ipoApplications[symbol] = units);
    _n.pushReplacement(_slide(_ipoApplied(symbol, ipo)));
  }

  Widget _ipoApplied(String symbol, _Ipo ipo) => IpoAppliedState(
        companyName: ipo.name,
        symbol: symbol,
        unitsRequested: _ipoApplications[symbol] ?? ipo.min,
        pricePerUnit: ipo.price,
        appliedDate: _today(),
        status: 'Pending',
        onBack: _pop,
        onBackToIpos: () => _resetTo(_ipoScreen()),
        onDestinationSelected: _goTab,
      );
}

/// Tells the flow whenever the route stack changes.
class _RouteObserver extends NavigatorObserver {
  _RouteObserver(this._onChange);

  final VoidCallback _onChange;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _onChange();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _onChange();

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) => _onChange();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => _onChange();
}

/// Market tab with the loading / error / stale states of BR-M08 and BR-I15.
class _MarketTab extends StatefulWidget {
  const _MarketTab({
    required this.feed,
    required this.securities,
    required this.onSecuritySelected,
    required this.onDestinationSelected,
  });

  final MarketFeed feed;
  final List<TradeSecurity> securities;
  final ValueChanged<TradeSecurity> onSecuritySelected;
  final ValueChanged<int> onDestinationSelected;

  @override
  State<_MarketTab> createState() => _MarketTabState();
}

enum _MarketPhase { loading, error, stale, ready }

class _MarketTabState extends State<_MarketTab> {
  _MarketPhase _phase = _MarketPhase.ready;

  @override
  void initState() {
    super.initState();
    if (widget.feed != MarketFeed.available) _load(widget.feed);
  }

  Future<void> _load(MarketFeed outcome) async {
    setState(() => _phase = _MarketPhase.loading);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      _phase = switch (outcome) {
        MarketFeed.available => _MarketPhase.ready,
        MarketFeed.failed => _MarketPhase.error,
        MarketFeed.stale => _MarketPhase.stale,
      };
    });
  }

  /// A retry succeeds in the demo, so the recovery path is visible.
  void _retry() => _load(MarketFeed.available);

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _MarketPhase.loading:
        return LoadingState(onDestinationSelected: widget.onDestinationSelected);
      case _MarketPhase.error:
        return ErrorState(
          onRetry: _retry,
          onDestinationSelected: widget.onDestinationSelected,
        );
      case _MarketPhase.stale:
        return StaleDataState(
          onRetry: _retry,
          onDestinationSelected: widget.onDestinationSelected,
        );
      case _MarketPhase.ready:
        return InvestorMarketScreen(
          securities: widget.securities,
          onSecuritySelected: widget.onSecuritySelected,
          onDestinationSelected: widget.onDestinationSelected,
        );
    }
  }
}
