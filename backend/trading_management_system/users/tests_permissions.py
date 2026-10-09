from datetime import date

from django.contrib.auth import get_user_model
from django.test import override_settings
from rest_framework.test import APITestCase

from ipo.models import IPO, IPOApplication
from market.models import Company, Security
from notifications.models import Notification
from trading.models import Holding, Order, Trade, TradingAccount, Transaction
from users.models import Broker, BrokerInvestorAssignment, Investor

User = get_user_model()

FAST_HASHER = ["django.contrib.auth.hashers.MD5PasswordHasher"]

ROLES = ["admin1", "broker1", "broker2", "investor1", "investor2", "nobody", "anon"]

# Only admins can read or write these.
ADMIN_ONLY_ENDPOINTS = [
    "/api/users/brokers/",
    "/api/market/broker-security-assignments/",
]

# Every role can read (investors and brokers see only their own rows). Only admins can write.
ADMIN_WRITE_ENDPOINTS = [
    "/api/users/investors/",
    "/api/users/broker-investor-assignments/",
    "/api/market/companies/",
    "/api/market/securities/",
    "/api/market/market-data/",
    "/api/ipo/ipos/",
    "/api/trading/trading-accounts/",
    "/api/trading/holdings/",
    "/api/trading/trades/",
    "/api/trading/transactions/",
    "/api/notifications/",
]

# Every role can read and create. Only admins can delete.
ANY_ROLE_ENDPOINTS = [
    "/api/ipo/applications/",
    "/api/trading/orders/",
]

ALL_ENDPOINTS = ADMIN_ONLY_ENDPOINTS + ADMIN_WRITE_ENDPOINTS + ANY_ROLE_ENDPOINTS


@override_settings(PASSWORD_HASHERS=FAST_HASHER)
class PermissionMatrixTests(APITestCase):
    @classmethod
    def setUpTestData(cls):
        password = "test-pass-12345"
        cls.users = {
            "admin1": User.objects.create_superuser("admin1", "admin@example.com", password),
            "broker1": User.objects.create_user("broker1", password=password),
            "broker2": User.objects.create_user("broker2", password=password),
            "investor1": User.objects.create_user("investor1", password=password),
            "investor2": User.objects.create_user("investor2", password=password),
            "nobody": User.objects.create_user("nobody", password=password),
        }

        # Two brokers, two investors. Each broker is assigned to one investor.
        cls.broker1 = Broker.objects.create(user=cls.users["broker1"], broker_code="B001", name="Broker One")
        cls.broker2 = Broker.objects.create(user=cls.users["broker2"], broker_code="B002", name="Broker Two")
        cls.inv1 = Investor.objects.create(user=cls.users["investor1"], client_id="C001")
        cls.inv2 = Investor.objects.create(user=cls.users["investor2"], client_id="C002")
        cls.assign1 = BrokerInvestorAssignment.objects.create(broker=cls.broker1, investor=cls.inv1)
        cls.assign2 = BrokerInvestorAssignment.objects.create(broker=cls.broker2, investor=cls.inv2)

        # Market data
        company = Company.objects.create(name="Test Co", registration_number="REG001")
        cls.security = Security.objects.create(
            company=company, symbol="TST", name="Test Security", isin="INE000000001"
        )

        # Two IPOs: applications for both investors on ipo1, ipo2 is left empty for create tests
        def make_ipo(name):
            return IPO.objects.create(
                security=cls.security,
                issue_name=name,
                issue_price=100,
                total_units=1000,
                minimum_units=10,
                maximum_units=100,
                opening_date=date(2026, 1, 1),
                closing_date=date(2026, 1, 10),
            )

        cls.ipo1 = make_ipo("IPO One")
        cls.ipo2 = make_ipo("IPO Two")
        cls.app1 = IPOApplication.objects.create(investor=cls.inv1, ipo=cls.ipo1, requested_units=10)
        cls.app2 = IPOApplication.objects.create(investor=cls.inv2, ipo=cls.ipo1, requested_units=10)

        # Trading data: one full chain per investor
        cls.acc1 = TradingAccount.objects.create(investor=cls.inv1, broker=cls.broker1, account_number="A001")
        cls.acc2 = TradingAccount.objects.create(investor=cls.inv2, broker=cls.broker2, account_number="A002")
        cls.hold1 = Holding.objects.create(investor=cls.inv1, security=cls.security, quantity=10, average_cost=100)
        cls.hold2 = Holding.objects.create(investor=cls.inv2, security=cls.security, quantity=5, average_cost=50)
        cls.order1 = Order.objects.create(
            trading_account=cls.acc1, security=cls.security, order_type="BUY", quantity=10, price=100
        )
        cls.order2 = Order.objects.create(
            trading_account=cls.acc2, security=cls.security, order_type="BUY", quantity=5, price=50
        )
        cls.trade1 = Trade.objects.create(order=cls.order1, quantity=10, execution_price=100)
        cls.trade2 = Trade.objects.create(order=cls.order2, quantity=5, execution_price=50)
        cls.txn1 = Transaction.objects.create(trade=cls.trade1, transaction_type="BUY", amount=1000)
        cls.txn2 = Transaction.objects.create(trade=cls.trade2, transaction_type="BUY", amount=250)
        cls.note1 = Notification.objects.create(investor=cls.inv1, title="Hello 1", message="For investor 1")
        cls.note2 = Notification.objects.create(investor=cls.inv2, title="Hello 2", message="For investor 2")

        # (endpoint, investor1's record, investor2's record)
        cls.detail_cases = [
            ("/api/users/investors/", cls.inv1, cls.inv2),
            ("/api/users/broker-investor-assignments/", cls.assign1, cls.assign2),
            ("/api/ipo/applications/", cls.app1, cls.app2),
            ("/api/trading/trading-accounts/", cls.acc1, cls.acc2),
            ("/api/trading/holdings/", cls.hold1, cls.hold2),
            ("/api/trading/orders/", cls.order1, cls.order2),
            ("/api/trading/trades/", cls.trade1, cls.trade2),
            ("/api/trading/transactions/", cls.txn1, cls.txn2),
            ("/api/notifications/", cls.note1, cls.note2),
        ]

    def act_as(self, who):
        self.client.force_authenticate(user=None if who == "anon" else self.users[who])

    # ---------- list access: every role against every endpoint ----------

    def test_list_access_for_every_role(self):
        for url in ALL_ENDPOINTS:
            for who in ROLES:
                if who == "anon":
                    expected = 401
                elif who == "nobody":
                    expected = 403
                elif url in ADMIN_ONLY_ENDPOINTS and who != "admin1":
                    expected = 403
                else:
                    expected = 200
                with self.subTest(url=url, who=who):
                    self.act_as(who)
                    self.assertEqual(self.client.get(url).status_code, expected)

    def test_me_endpoint(self):
        for who in ROLES:
            with self.subTest(who=who):
                self.act_as(who)
                expected = 401 if who == "anon" else 200
                self.assertEqual(self.client.get("/api/auth/me/").status_code, expected)

    # ---------- write access: create (POST), update (PATCH), delete ----------

    def test_create_access_for_every_role(self):
        # An empty body: 403 means the role is blocked, 400 means it passed the
        # permission check and only failed validation.
        for url in ALL_ENDPOINTS:
            for who in ROLES:
                if who == "anon":
                    expected = 401
                elif who == "nobody":
                    expected = 403
                elif who == "admin1" or url in ANY_ROLE_ENDPOINTS:
                    expected = 400
                else:
                    expected = 403
                with self.subTest(url=url, who=who):
                    self.act_as(who)
                    self.assertEqual(self.client.post(url, {}, format="json").status_code, expected)

    def test_only_admins_can_update_admin_managed_records(self):
        for url in ADMIN_ONLY_ENDPOINTS + ADMIN_WRITE_ENDPOINTS:
            for who in ["broker1", "investor1", "nobody"]:
                with self.subTest(url=url, who=who):
                    self.act_as(who)
                    self.assertEqual(self.client.patch(url + "1/", {}, format="json").status_code, 403)

    def test_only_admins_can_delete(self):
        for url in ALL_ENDPOINTS:
            for who in ["broker1", "broker2", "investor1", "investor2", "nobody"]:
                with self.subTest(url=url, who=who):
                    self.act_as(who)
                    self.assertEqual(self.client.delete(url + "1/").status_code, 403)
            with self.subTest(url=url, who="anon"):
                self.act_as("anon")
                self.assertEqual(self.client.delete(url + "1/").status_code, 401)

    # ---------- another user's data: detail pages ----------

    def test_reading_own_and_other_investors_records(self):
        # who -> (status for investor1's record, status for investor2's record)
        expected = {
            "admin1": (200, 200),
            "investor1": (200, 404),
            "investor2": (404, 200),
            "broker1": (200, 404),
            "broker2": (404, 200),
            "nobody": (403, 403),
            "anon": (401, 401),
        }
        for url, record1, record2 in self.detail_cases:
            for who, (status1, status2) in expected.items():
                with self.subTest(url=url, who=who, record="investor1"):
                    self.act_as(who)
                    self.assertEqual(self.client.get(f"{url}{record1.id}/").status_code, status1)
                with self.subTest(url=url, who=who, record="investor2"):
                    self.act_as(who)
                    self.assertEqual(self.client.get(f"{url}{record2.id}/").status_code, status2)

    def test_lists_are_filtered_to_own_data(self):
        # who -> number of records they should see in each filtered list
        expected_counts = {"admin1": 2, "investor1": 1, "investor2": 1, "broker1": 1, "broker2": 1}
        for url, _record1, _record2 in self.detail_cases:
            for who, count in expected_counts.items():
                with self.subTest(url=url, who=who):
                    self.act_as(who)
                    self.assertEqual(self.client.get(url).data["count"], count)

    # ---------- another user's data: writes ----------

    def test_cannot_edit_other_investors_orders_and_applications(self):
        cases = [
            ("investor1", "/api/trading/orders/", self.order2, {"quantity": "99"}),
            ("investor2", "/api/trading/orders/", self.order1, {"quantity": "99"}),
            ("broker1", "/api/trading/orders/", self.order2, {"quantity": "99"}),
            ("broker2", "/api/trading/orders/", self.order1, {"quantity": "99"}),
            ("investor1", "/api/ipo/applications/", self.app2, {"requested_units": 20}),
            ("broker1", "/api/ipo/applications/", self.app2, {"requested_units": 20}),
        ]
        for who, url, record, body in cases:
            with self.subTest(who=who, url=url):
                self.act_as(who)
                self.assertEqual(self.client.patch(f"{url}{record.id}/", body, format="json").status_code, 404)

    def test_cannot_create_order_for_someone_elses_account(self):
        def payload(account):
            return {
                "trading_account": account.id,
                "security": self.security.id,
                "order_type": "BUY",
                "quantity": "5",
                "price": "10",
            }

        cases = [
            ("investor1", self.acc1, 201),
            ("investor1", self.acc2, 403),
            ("investor2", self.acc1, 403),
            ("broker1", self.acc1, 201),  # assigned investor
            ("broker1", self.acc2, 403),  # not assigned
            ("admin1", self.acc2, 201),
        ]
        for who, account, expected in cases:
            with self.subTest(who=who, account=account.account_number):
                self.act_as(who)
                response = self.client.post("/api/trading/orders/", payload(account), format="json")
                self.assertEqual(response.status_code, expected)

    def test_cannot_apply_to_ipo_for_someone_else(self):
        def payload(investor):
            return {"investor": investor.id, "ipo": self.ipo2.id, "requested_units": 10}

        cases = [
            ("investor1", self.inv1, 201),
            ("investor1", self.inv2, 403),
            ("investor2", self.inv1, 403),
            ("broker1", self.inv2, 403),
            ("admin1", self.inv2, 201),
        ]
        for who, investor, expected in cases:
            with self.subTest(who=who, investor=investor.client_id):
                self.act_as(who)
                response = self.client.post("/api/ipo/applications/", payload(investor), format="json")
                self.assertEqual(response.status_code, expected)