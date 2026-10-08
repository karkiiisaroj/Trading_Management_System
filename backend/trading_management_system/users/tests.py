from django.contrib.auth import get_user_model
from rest_framework.test import APITestCase

from market.models import Company, Security
from trading.models import Order, TradingAccount
from users.models import Broker, BrokerInvestorAssignment, Investor

User = get_user_model()
PASSWORD = "test-pass-12345"


class BaseTestCase(APITestCase):
    @classmethod
    def setUpTestData(cls):
        # Users
        cls.admin = User.objects.create_superuser("admin1", "admin@example.com", PASSWORD)
        cls.inv1_user = User.objects.create_user("investor1", password=PASSWORD)
        cls.inv2_user = User.objects.create_user("investor2", password=PASSWORD)
        cls.broker_user = User.objects.create_user("broker1", password=PASSWORD)
        cls.nobody = User.objects.create_user("nobody", password=PASSWORD)

        # Profiles
        cls.broker = Broker.objects.create(user=cls.broker_user, broker_code="B001", name="Broker One")
        cls.inv1 = Investor.objects.create(user=cls.inv1_user, client_id="C001")
        cls.inv2 = Investor.objects.create(user=cls.inv2_user, client_id="C002")

        # Broker is assigned to investor1 only
        BrokerInvestorAssignment.objects.create(broker=cls.broker, investor=cls.inv1)

        # Market data
        cls.company = Company.objects.create(name="Test Co", registration_number="REG001")
        cls.security = Security.objects.create(
            company=cls.company, symbol="TST", name="Test Security", isin="INE000000001"
        )

        # Accounts and orders: one per investor
        cls.acc1 = TradingAccount.objects.create(investor=cls.inv1, broker=cls.broker, account_number="A001")
        cls.acc2 = TradingAccount.objects.create(investor=cls.inv2, broker=cls.broker, account_number="A002")
        cls.order1 = Order.objects.create(
            trading_account=cls.acc1, security=cls.security, order_type="BUY", quantity=10, price=100
        )
        cls.order2 = Order.objects.create(
            trading_account=cls.acc2, security=cls.security, order_type="BUY", quantity=5, price=50
        )

    def login(self, username):
        response = self.client.post(
            "/api/auth/login/", {"username": username, "password": PASSWORD}, format="json"
        )
        self.assertEqual(response.status_code, 200)
        return response.data

    def auth_as(self, username):
        tokens = self.login(username)
        self.client.credentials(HTTP_AUTHORIZATION="Bearer " + tokens["access"])
        return tokens

    def new_order_payload(self, account):
        return {
            "trading_account": account.id,
            "security": self.security.id,
            "order_type": "BUY",
            "quantity": "5",
            "price": "10",
        }


class AuthenticationTests(BaseTestCase):
    def test_login_returns_tokens(self):
        tokens = self.login("investor1")
        self.assertIn("access", tokens)
        self.assertIn("refresh", tokens)

    def test_login_wrong_password_is_401(self):
        response = self.client.post(
            "/api/auth/login/", {"username": "investor1", "password": "wrong"}, format="json"
        )
        self.assertEqual(response.status_code, 401)

    def test_no_token_is_401(self):
        response = self.client.get("/api/market/companies/")
        self.assertEqual(response.status_code, 401)

    def test_fake_token_is_401(self):
        self.client.credentials(HTTP_AUTHORIZATION="Bearer not-a-real-token")
        response = self.client.get("/api/market/companies/")
        self.assertEqual(response.status_code, 401)

    def test_valid_token_is_200(self):
        self.auth_as("investor1")
        response = self.client.get("/api/market/companies/")
        self.assertEqual(response.status_code, 200)

    def test_refresh_returns_new_access_token(self):
        tokens = self.login("investor1")
        response = self.client.post("/api/auth/refresh/", {"refresh": tokens["refresh"]}, format="json")
        self.assertEqual(response.status_code, 200)
        self.assertIn("access", response.data)

    def test_logout_blocks_refresh_token(self):
        tokens = self.auth_as("investor1")
        response = self.client.post("/api/auth/logout/", {"refresh": tokens["refresh"]}, format="json")
        self.assertEqual(response.status_code, 205)

        self.client.credentials()  # remove the header
        again = self.client.post("/api/auth/refresh/", {"refresh": tokens["refresh"]}, format="json")
        self.assertEqual(again.status_code, 401)

    def test_logout_without_refresh_token_is_400(self):
        self.auth_as("investor1")
        response = self.client.post("/api/auth/logout/", {}, format="json")
        self.assertEqual(response.status_code, 400)


class RoleTests(BaseTestCase):
    def test_me_shows_roles(self):
        expected = {
            "admin1": "admin",
            "broker1": "broker",
            "investor1": "investor",
            "nobody": None,
        }
        for username, role in expected.items():
            self.auth_as(username)
            response = self.client.get("/api/auth/me/")
            self.assertEqual(response.status_code, 200)
            self.assertEqual(response.data["role"], role, username)

    def test_user_without_role_is_403(self):
        self.auth_as("nobody")
        response = self.client.get("/api/market/companies/")
        self.assertEqual(response.status_code, 403)

    def test_investor_cannot_create_company(self):
        self.auth_as("investor1")
        response = self.client.post(
            "/api/market/companies/", {"name": "New Co", "registration_number": "REG002"}, format="json"
        )
        self.assertEqual(response.status_code, 403)

    def test_investor_cannot_see_brokers(self):
        self.auth_as("investor1")
        response = self.client.get("/api/users/brokers/")
        self.assertEqual(response.status_code, 403)

    def test_admin_can_see_brokers(self):
        self.auth_as("admin1")
        response = self.client.get("/api/users/brokers/")
        self.assertEqual(response.status_code, 200)


class DataIsolationTests(BaseTestCase):
    def test_investor_sees_only_own_orders(self):
        self.auth_as("investor1")
        response = self.client.get("/api/trading/orders/")
        self.assertEqual(response.status_code, 200)
        ids = [row["id"] for row in response.data["results"]]
        self.assertEqual(ids, [self.order1.id])

    def test_investor_cannot_open_other_investors_order(self):
        self.auth_as("investor1")
        response = self.client.get(f"/api/trading/orders/{self.order2.id}/")
        self.assertEqual(response.status_code, 404)

    def test_investor_sees_only_self_in_investor_list(self):
        self.auth_as("investor1")
        response = self.client.get("/api/users/investors/")
        self.assertEqual(response.data["count"], 1)

    def test_broker_sees_only_assigned_investors_orders(self):
        self.auth_as("broker1")
        response = self.client.get("/api/trading/orders/")
        ids = [row["id"] for row in response.data["results"]]
        self.assertEqual(ids, [self.order1.id])

    def test_broker_sees_only_assigned_investors(self):
        self.auth_as("broker1")
        response = self.client.get("/api/users/investors/")
        self.assertEqual(response.data["count"], 1)

    def test_broker_cannot_see_brokers_list(self):
        self.auth_as("broker1")
        response = self.client.get("/api/users/brokers/")
        self.assertEqual(response.status_code, 403)

    def test_admin_sees_all_orders(self):
        self.auth_as("admin1")
        response = self.client.get("/api/trading/orders/")
        self.assertEqual(response.data["count"], 2)


class OrderRuleTests(BaseTestCase):
    def test_investor_can_create_order_on_own_account(self):
        self.auth_as("investor1")
        response = self.client.post("/api/trading/orders/", self.new_order_payload(self.acc1), format="json")
        self.assertEqual(response.status_code, 201)

    def test_investor_cannot_create_order_on_other_account(self):
        self.auth_as("investor1")
        response = self.client.post("/api/trading/orders/", self.new_order_payload(self.acc2), format="json")
        self.assertEqual(response.status_code, 403)

    def test_investor_cannot_set_status(self):
        self.auth_as("investor1")
        payload = self.new_order_payload(self.acc1)
        payload["status"] = "FILLED"
        response = self.client.post("/api/trading/orders/", payload, format="json")
        self.assertEqual(response.status_code, 201)
        self.assertEqual(Order.objects.get(pk=response.data["id"]).status, "PENDING")

    def test_investor_can_edit_pending_order(self):
        self.auth_as("investor1")
        response = self.client.patch(
            f"/api/trading/orders/{self.order1.id}/", {"quantity": "20"}, format="json"
        )
        self.assertEqual(response.status_code, 200)

    def test_investor_cannot_edit_filled_order(self):
        Order.objects.filter(pk=self.order1.id).update(status="FILLED")
        self.auth_as("investor1")
        response = self.client.patch(
            f"/api/trading/orders/{self.order1.id}/", {"quantity": "20"}, format="json"
        )
        self.assertEqual(response.status_code, 403)

    def test_investor_cannot_move_order_to_other_account(self):
        self.auth_as("investor1")
        response = self.client.patch(
            f"/api/trading/orders/{self.order1.id}/", {"trading_account": self.acc2.id}, format="json"
        )
        self.assertEqual(response.status_code, 403)

    def test_investor_cannot_delete_order(self):
        self.auth_as("investor1")
        response = self.client.delete(f"/api/trading/orders/{self.order1.id}/")
        self.assertEqual(response.status_code, 403)

    def test_admin_can_edit_status_and_delete(self):
        self.auth_as("admin1")
        response = self.client.patch(
            f"/api/trading/orders/{self.order1.id}/", {"status": "FILLED"}, format="json"
        )
        self.assertEqual(response.status_code, 200)
        self.assertEqual(Order.objects.get(pk=self.order1.id).status, "FILLED")

        response = self.client.delete(f"/api/trading/orders/{self.order1.id}/")
        self.assertEqual(response.status_code, 204)


class ProtectedDeleteTests(BaseTestCase):
    def test_deleting_company_with_securities_is_409(self):
        self.auth_as("admin1")
        response = self.client.delete(f"/api/market/companies/{self.company.id}/")
        self.assertEqual(response.status_code, 409)