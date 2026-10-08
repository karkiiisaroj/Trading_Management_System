from rest_framework import viewsets
from .models import Broker, Investor, BrokerInvestorAssignment
from .serializers import (
    BrokerSerializer,
    InvestorSerializer,
    BrokerInvestorAssignmentSerializer,
)


class BrokerViewSet(viewsets.ModelViewSet):
    queryset = Broker.objects.all().order_by('id')
    serializer_class = BrokerSerializer


class InvestorViewSet(viewsets.ModelViewSet):
    queryset = Investor.objects.all().order_by('id')
    serializer_class = InvestorSerializer


class BrokerInvestorAssignmentViewSet(viewsets.ModelViewSet):
    queryset = BrokerInvestorAssignment.objects.all().order_by('id')
    serializer_class = BrokerInvestorAssignmentSerializer