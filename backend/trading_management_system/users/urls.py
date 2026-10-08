from rest_framework.routers import DefaultRouter
from .views import BrokerViewSet, InvestorViewSet, BrokerInvestorAssignmentViewSet

router = DefaultRouter()
router.register('brokers', BrokerViewSet)
router.register('investors', InvestorViewSet)
router.register('broker-investor-assignments', BrokerInvestorAssignmentViewSet)

urlpatterns = router.urls