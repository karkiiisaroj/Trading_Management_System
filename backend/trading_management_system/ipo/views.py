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

    def perform_create(self, serializer):
        investor = serializer.validated_data['investor']
        user = self.request.user
        if get_role(user) != 'admin' and investor.id not in visible_investor_ids(user):
            raise PermissionDenied('You cannot apply on behalf of this investor.')
        serializer.save()