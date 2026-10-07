from django.contrib import admin
from .models import Company, Security, MarketData, BrokerSecurityAssignment

admin.site.register([Company, Security, MarketData, BrokerSecurityAssignment])