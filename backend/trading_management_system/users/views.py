from rest_framework import status, viewsets
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.exceptions import TokenError
from rest_framework_simplejwt.tokens import RefreshToken

from .models import Broker, Investor, BrokerInvestorAssignment
from .permissions import IsAdmin, IsAdminOrReadOnly, RoleFilteredMixin, get_role
from .serializers import (
    BrokerSerializer,
    InvestorSerializer,
    BrokerInvestorAssignmentSerializer,
)


class BrokerViewSet(viewsets.ModelViewSet):
    queryset = Broker.objects.all().order_by('id')
    serializer_class = BrokerSerializer
    permission_classes = [IsAdmin]


class InvestorViewSet(RoleFilteredMixin, viewsets.ModelViewSet):
    queryset = Investor.objects.all().order_by('id')
    serializer_class = InvestorSerializer
    permission_classes = [IsAdminOrReadOnly]
    investor_field = 'id'


class BrokerInvestorAssignmentViewSet(RoleFilteredMixin, viewsets.ModelViewSet):
    queryset = BrokerInvestorAssignment.objects.all().order_by('id')
    serializer_class = BrokerInvestorAssignmentSerializer
    permission_classes = [IsAdminOrReadOnly]


class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        refresh = request.data.get('refresh')
        if not refresh:
            return Response({'detail': 'Refresh token is required.'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            RefreshToken(refresh).blacklist()
        except TokenError:
            return Response({'detail': 'Invalid or expired token.'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(status=status.HTTP_205_RESET_CONTENT)


class MeView(APIView):
    """Tells the app who is logged in and what role they have."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        return Response({'id': user.id, 'username': user.username, 'role': get_role(user)})