from django.contrib import admin
from .models import TradingAccount, Holding, Order, Trade, Transaction

admin.site.register([TradingAccount, Holding, Order, Trade, Transaction])