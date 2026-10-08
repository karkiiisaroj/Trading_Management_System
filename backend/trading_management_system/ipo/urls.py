from rest_framework.routers import DefaultRouter
from .views import IPOViewSet, IPOApplicationViewSet

router = DefaultRouter()
router.register('ipos', IPOViewSet)
router.register('applications', IPOApplicationViewSet)

urlpatterns = router.urls