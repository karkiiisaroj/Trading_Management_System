from rest_framework import viewsets
from .models import IPO, IPOApplication
from .serializers import IPOSerializer, IPOApplicationSerializer


class IPOViewSet(viewsets.ModelViewSet):
    queryset = IPO.objects.all().order_by('id')
    serializer_class = IPOSerializer


class IPOApplicationViewSet(viewsets.ModelViewSet):
    queryset = IPOApplication.objects.all().order_by('id')
    serializer_class = IPOApplicationSerializer