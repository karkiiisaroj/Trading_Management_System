from django.db import models


class Company(models.Model):
    name = models.CharField(max_length=255)
    registration_number = models.CharField(max_length=50, unique=True)
    description = models.TextField(blank=True)
    sector = models.CharField(max_length=100, blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class Security(models.Model):
    company = models.ForeignKey(Company, on_delete=models.PROTECT)
    symbol = models.CharField(max_length=20, unique=True)
    name = models.CharField(max_length=255)
    security_type = models.CharField(max_length=50, blank=True)
    isin = models.CharField(max_length=12, unique=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.symbol


class MarketData(models.Model):
    security = models.ForeignKey(Security, on_delete=models.CASCADE)
    trading_date = models.DateField()
    open_price = models.DecimalField(max_digits=18, decimal_places=2, null=True, blank=True)
    high_price = models.DecimalField(max_digits=18, decimal_places=2, null=True, blank=True)
    low_price = models.DecimalField(max_digits=18, decimal_places=2, null=True, blank=True)
    close_price = models.DecimalField(max_digits=18, decimal_places=2, null=True, blank=True)
    volume = models.BigIntegerField(default=0)
    turnover = models.DecimalField(max_digits=22, decimal_places=2, default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("security", "trading_date")


class BrokerSecurityAssignment(models.Model):
    broker = models.ForeignKey("users.Broker", on_delete=models.CASCADE)
    security = models.ForeignKey(Security, on_delete=models.CASCADE)
    assigned_at = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        unique_together = ("broker", "security")