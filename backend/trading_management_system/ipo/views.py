from rest_framework import viewsets
from rest_framework.exceptions import PermissionDenied

from users.permissions import (
    IsAdminOrReadOnly,
    IsAnyRole,
    RoleFilteredMixin,
    get_role,
    visible_investor_ids,
)
from .models import IPO, IPOApplication
from .serializers import IPOSerializer, IPOApplicationSerializer


class IPOViewSet(viewsets.ModelViewSet):
    queryset = IPO.objects.all().order_by('id')
    serializer_class = IPOSerializer
    permission_classes = [IsAdminOrReadOnly]


class IPOApplicationViewSet(RoleFilteredMixin, viewsets.ModelViewSet):
    queryset = IPOApplication.objects.all().order_by('id')
    serializer_class = IPOApplicationSerializer
    permission_classes = [IsAnyRole]

    def _check_investor(self, investor):
        user = self.request.user
        if get_role(user) != 'admin' and investor.id not in visible_investor_ids(user):
            raise PermissionDenied('You cannot apply on behalf of this investor.')

    def perform_create(self, serializer):
        self._check_investor(serializer.validated_data['investor'])
        serializer.save()

    def perform_update(self, serializer):
        investor = serializer.validated_data.get('investor', serializer.instance.investor)
        self._check_investor(investor)
        serializer.save()