from rest_framework import serializers
from .models import Company, Security, MarketData, BrokerSecurityAssignment


class CompanySerializer(serializers.ModelSerializer):
    class Meta:
        model = Company
        fields = '__all__'


class SecuritySerializer(serializers.ModelSerializer):
    class Meta:
        model = Security
        fields = '__all__'


class MarketDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = MarketData
        fields = '__all__'


class BrokerSecurityAssignmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = BrokerSecurityAssignment
        fields = '__all__'