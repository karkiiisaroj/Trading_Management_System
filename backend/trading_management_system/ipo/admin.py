from django.contrib import admin
from .models import IPO, IPOApplication

admin.site.register([IPO, IPOApplication])