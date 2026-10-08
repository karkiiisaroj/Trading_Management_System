from rest_framework.routers import DefaultRouter
from .views import (
    CompanyViewSet,
    SecurityViewSet,
    MarketDataViewSet,
    BrokerSecurityAssignmentViewSet,
)

router = DefaultRouter()
router.register('companies', CompanyViewSet)
router.register('securities', SecurityViewSet)
router.register('market-data', MarketDataViewSet)
router.register('broker-security-assignments', BrokerSecurityAssignmentViewSet)

urlpatterns = router.urls