from rest_framework import serializers
from .models import Broker, Investor, BrokerInvestorAssignment


class BrokerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Broker
        fields = '__all__'


class InvestorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Investor
        fields = '__all__'


class BrokerInvestorAssignmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = BrokerInvestorAssignment
        fields = '__all__'