from django.contrib import admin
from .models import Broker, Investor, BrokerInvestorAssignment

admin.site.register([Broker, Investor, BrokerInvestorAssignment])