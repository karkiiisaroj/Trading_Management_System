from rest_framework import serializers
from .models import IPO, IPOApplication


class IPOSerializer(serializers.ModelSerializer):
    class Meta:
        model = IPO
        fields = '__all__'


class IPOApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = IPOApplication
        fields = '__all__'