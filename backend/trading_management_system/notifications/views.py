from rest_framework import viewsets

from users.permissions import IsAdminOrReadOnly, RoleFilteredMixin
from .models import Notification
from .serializers import NotificationSerializer


class NotificationViewSet(RoleFilteredMixin, viewsets.ModelViewSet):
    queryset = Notification.objects.all().order_by('-id')
    serializer_class = NotificationSerializer
    permission_classes = [IsAdminOrReadOnly]
    investor_field = 'investor'