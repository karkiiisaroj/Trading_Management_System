from django.db import models


class TradingAccount(models.Model):
    investor = models.ForeignKey("users.Investor", on_delete=models.PROTECT)
    broker = models.ForeignKey("users.Broker", on_delete=models.PROTECT)
    account_number = models.CharField(max_length=30, unique=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.account_number


class Holding(models.Model):
    investor = models.ForeignKey("users.Investor", on_delete=models.CASCADE)
    security = models.ForeignKey("market.Security", on_delete=models.PROTECT)
    quantity = models.DecimalField(max_digits=18, decimal_places=4, default=0)
    average_cost = models.DecimalField(max_digits=18, decimal_places=4, default=0)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ("investor", "security")


class Order(models.Model):
    trading_account = models.ForeignKey(TradingAccount, on_delete=models.PROTECT)
    security = models.ForeignKey("market.Security", on_delete=models.PROTECT)
    order_type = models.CharField(max_length=10)  # BUY / SELL
    quantity = models.DecimalField(max_digits=18, decimal_places=4)
    price = models.DecimalField(max_digits=18, decimal_places=2)
    status = models.CharField(max_length=20, default="PENDING")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


class Trade(models.Model):
    order = models.ForeignKey(Order, on_delete=models.PROTECT)
    quantity = models.DecimalField(max_digits=18, decimal_places=4)
    execution_price = models.DecimalField(max_digits=18, decimal_places=2)
    executed_at = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, default="EXECUTED")


class Transaction(models.Model):
    trade = models.OneToOneField(Trade, on_delete=models.PROTECT)
    transaction_type = models.CharField(max_length=30)
    amount = models.DecimalField(max_digits=22, decimal_places=2)
    status = models.CharField(max_length=20, default="PENDING")
    created_at = models.DateTimeField(auto_now_add=True)