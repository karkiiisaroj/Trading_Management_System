from rest_framework import viewsets
from .models import TradingAccount, Holding, Order, Trade, Transaction
from .serializers import (
    TradingAccountSerializer,
    HoldingSerializer,
    OrderSerializer,
    TradeSerializer,
    TransactionSerializer,
)


class TradingAccountViewSet(viewsets.ModelViewSet):
    queryset = TradingAccount.objects.all().order_by('id')
    serializer_class = TradingAccountSerializer


class HoldingViewSet(viewsets.ModelViewSet):
    queryset = Holding.objects.all().order_by('id')
    serializer_class = HoldingSerializer


class OrderViewSet(viewsets.ModelViewSet):
    queryset = Order.objects.all().order_by('id')
    serializer_class = OrderSerializer


class TradeViewSet(viewsets.ModelViewSet):
    queryset = Trade.objects.all().order_by('id')
    serializer_class = TradeSerializer


class TransactionViewSet(viewsets.ModelViewSet):
    queryset = Transaction.objects.all().order_by('id')
    serializer_class = TransactionSerializer