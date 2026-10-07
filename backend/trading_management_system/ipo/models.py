from django.db import models


class IPO(models.Model):
    security = models.ForeignKey("market.Security", on_delete=models.PROTECT)
    issue_name = models.CharField(max_length=255)
    issue_price = models.DecimalField(max_digits=18, decimal_places=2)
    total_units = models.BigIntegerField()
    minimum_units = models.BigIntegerField()
    maximum_units = models.BigIntegerField()
    opening_date = models.DateField()
    closing_date = models.DateField()
    status = models.CharField(max_length=20, default="UPCOMING")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.issue_name


class IPOApplication(models.Model):
    investor = models.ForeignKey("users.Investor", on_delete=models.CASCADE)
    ipo = models.ForeignKey(IPO, on_delete=models.CASCADE)
    requested_units = models.BigIntegerField()
    allotted_units = models.BigIntegerField(null=True, blank=True)
    status = models.CharField(max_length=20, default="PENDING")
    applied_at = models.DateTimeField(auto_now_add=True)
    processed_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        unique_together = ("investor", "ipo")