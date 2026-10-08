from rest_framework import serializers

from users.permissions import AdminOnlyFieldsMixin
from .models import IPO, IPOApplication


class IPOSerializer(serializers.ModelSerializer):
    class Meta:
        model = IPO
        fields = '__all__'


class IPOApplicationSerializer(AdminOnlyFieldsMixin, serializers.ModelSerializer):
    admin_only_fields = ['status', 'allotted_units', 'processed_at']

    class Meta:
        model = IPOApplication
        fields = '__all__'