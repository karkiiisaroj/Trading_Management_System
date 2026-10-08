from rest_framework.permissions import BasePermission, SAFE_METHODS

from .models import BrokerInvestorAssignment


def get_role(user):
    if not user or not user.is_authenticated:
        return None
    if user.is_staff or user.is_superuser:
        return 'admin'
    if hasattr(user, 'broker'):
        return 'broker'
    if hasattr(user, 'investor'):
        return 'investor'
    return None


def visible_investor_ids(user):
    role = get_role(user)
    if role == 'investor':
        return [user.investor.id]
    if role == 'broker':
        return list(
            BrokerInvestorAssignment.objects
            .filter(broker=user.broker, is_active=True)
            .values_list('investor_id', flat=True)
        )
    return []


class IsAdmin(BasePermission):
    def has_permission(self, request, view):
        return get_role(request.user) == 'admin'


class IsAnyRole(BasePermission):
    def has_permission(self, request, view):
        return get_role(request.user) is not None


class IsAdminOrReadOnly(BasePermission):
    """Admin can do everything. Brokers and investors can only read."""
    def has_permission(self, request, view):
        role = get_role(request.user)
        if role == 'admin':
            return True
        return role is not None and request.method in SAFE_METHODS


class RoleFilteredMixin:
    """Admin sees all rows. Investor and broker see only their investors' rows."""
    investor_field = 'investor'

    def get_queryset(self):
        qs = super().get_queryset()
        role = get_role(self.request.user)
        if role == 'admin':
            return qs
        if role in ('investor', 'broker'):
            ids = visible_investor_ids(self.request.user)
            return qs.filter(**{f'{self.investor_field}__in': ids})
        return qs.none()

class AdminOnlyFieldsMixin:
    """Fields listed in admin_only_fields can only be written by admins."""
    admin_only_fields = []

    def get_fields(self):
        fields = super().get_fields()
        request = self.context.get('request')
        if not request or get_role(request.user) != 'admin':
            for name in self.admin_only_fields:
                if name in fields:
                    fields[name].read_only = True
        return fields