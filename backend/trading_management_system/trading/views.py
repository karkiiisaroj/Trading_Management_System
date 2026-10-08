from rest_framework import viewsets
from rest_framework.exceptions import PermissionDenied

from users.permissions import (
    IsAdminOrReadOnly,
    IsAnyRole,
    RoleFilteredMixin,
    get_role,
    visible_investor_ids,
)
from .models import TradingAccount, Holding, Order, Trade, Transaction
from .serializers import (
    TradingAccountSerializer,
    HoldingSerializer,
    OrderSerializer,
    TradeSerializer,
    TransactionSerializer,
)


class TradingAccountViewSet(RoleFilteredMixin, viewsets.ModelViewSet):
    queryset = TradingAccount.objects.all().order_by('id')
    serializer_class = TradingAccountSerializer
    permission_classes = [IsAdminOrReadOnly]
    investor_field = 'investor'


class HoldingViewSet(RoleFilteredMixin, viewsets.ModelViewSet):
    queryset = Holding.objects.all().order_by('id')
    serializer_class = HoldingSerializer
    permission_classes = [IsAdminOrReadOnly]
    investor_field = 'investor'


class OrderViewSet(RoleFilteredMixin, viewsets.ModelViewSet):
    queryset = Order.objects.all().order_by('id')
    serializer_class = OrderSerializer
    permission_classes = [IsAnyRole]
    investor_field = 'trading_account__investor'

    def perform_create(self, serializer):
        account = serializer.validated_data['trading_account']
        user = self.request.user
        if get_role(user) != 'admin' and account.investor_id not in visible_investor_ids(user):
            raise PermissionDenied('You cannot place orders for this account.')
        serializer.save()


class TradeViewSet(RoleFilteredMixin, viewsets.ModelViewSet):
    queryset = Trade.objects.all().order_by('id')
    serializer_class = TradeSerializer
    permission_classes = [IsAdminOrReadOnly]
    investor_field = 'order__trading_account__investor'


class TransactionViewSet(RoleFilteredMixin, viewsets.ModelViewSet):
    queryset = Transaction.objects.all().order_by('id')
    serializer_class = TransactionSerializer
    permission_classes = [IsAdminOrReadOnly]
    investor_field = 'trade__order__trading_account__investor'