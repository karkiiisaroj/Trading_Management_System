from rest_framework.routers import DefaultRouter
from .views import (
    TradingAccountViewSet,
    HoldingViewSet,
    OrderViewSet,
    TradeViewSet,
    TransactionViewSet,
)

router = DefaultRouter()
router.register('trading-accounts', TradingAccountViewSet)
router.register('holdings', HoldingViewSet)
router.register('orders', OrderViewSet)
router.register('trades', TradeViewSet)
router.register('transactions', TransactionViewSet)

urlpatterns = router.urls