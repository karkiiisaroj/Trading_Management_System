from rest_framework import viewsets
from .models import Company, Security, MarketData, BrokerSecurityAssignment
from .searializers import (
    CompanySerializer,
    SecuritySerializer,
    MarketDataSerializer,
    BrokerSecurityAssignmentSerializer,
)


class CompanyViewSet(viewsets.ModelViewSet):
    queryset = Company.objects.all().order_by('id')
    serializer_class = CompanySerializer


class SecurityViewSet(viewsets.ModelViewSet):
    queryset = Security.objects.all().order_by('id')
    serializer_class = SecuritySerializer


class MarketDataViewSet(viewsets.ModelViewSet):
    queryset = MarketData.objects.all().order_by('id')
    serializer_class = MarketDataSerializer


class BrokerSecurityAssignmentViewSet(viewsets.ModelViewSet):
    queryset = BrokerSecurityAssignment.objects.all().order_by('id')
    serializer_class = BrokerSecurityAssignmentSerializer