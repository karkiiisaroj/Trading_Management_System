from rest_framework import viewsets

from users.permissions import IsAdmin, IsAdminOrReadOnly
from .models import Company, Security, MarketData, BrokerSecurityAssignment
from .serializers import (
    CompanySerializer,
    SecuritySerializer,
    MarketDataSerializer,
    BrokerSecurityAssignmentSerializer,
)


class CompanyViewSet(viewsets.ModelViewSet):
    queryset = Company.objects.all().order_by('id')
    serializer_class = CompanySerializer
    permission_classes = [IsAdminOrReadOnly]


class SecurityViewSet(viewsets.ModelViewSet):
    queryset = Security.objects.all().order_by('id')
    serializer_class = SecuritySerializer
    permission_classes = [IsAdminOrReadOnly]


class MarketDataViewSet(viewsets.ModelViewSet):
    queryset = MarketData.objects.all().order_by('id')
    serializer_class = MarketDataSerializer
    permission_classes = [IsAdminOrReadOnly]


class BrokerSecurityAssignmentViewSet(viewsets.ModelViewSet):
    queryset = BrokerSecurityAssignment.objects.all().order_by('id')
    serializer_class = BrokerSecurityAssignmentSerializer
    permission_classes = [IsAdmin]