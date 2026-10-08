from rest_framework import serializers

from users.permissions import AdminOnlyFieldsMixin
from .models import TradingAccount, Holding, Order, Trade, Transaction

class TradingAccountSerializer(serializers.ModelSerializer):
    class Meta:
        model = TradingAccount
        fields = '__all__'


class HoldingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Holding
        fields = '__all__'


class OrderSerializer(AdminOnlyFieldsMixin, serializers.ModelSerializer):
    admin_only_fields = ['status']

    class Meta:
        model = Order
        fields = '__all__'


class TradeSerializer(serializers.ModelSerializer):
    class Meta:
        model = Trade
        fields = '__all__'


class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = '__all__'