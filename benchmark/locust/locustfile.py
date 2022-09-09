from locust import HttpUser, events, task, between


class User(HttpUser):
    wait_time = between(1, 5)

    # @task
    # def search(self):
    #     with self.client.post("/house/search", catch_response=True) as response:
    #         if response.status_code != 200:
    #             response.failure("search: Got wrong response")

    # @task
    # def search_price(self):
    #     with self.client.post("/house/search?price1=1000&price2=6000", catch_response=True) as response:
    #         if response.status_code != 200:
    #             response.failure("search_price: Got wrong response")

    @task
    def search_district(self):
        with self.client.post("/house/search?district=%E9%97%B5%E8%A1%8C%2C%E6%B5%A6%E4%B8%9C%2C%E5%BE%90%E6%B1%87",
                              catch_response=True) as response:
            if response.status_code != 200:
                response.failure("search_district: Got wrong response")

    @task
    def search_rent_type(self):
        with self.client.post("/house/search",
                              catch_response=True) as response:
            if response.status_code != 200:
                response.failure("search_rent_type: Got wrong response")

    # @task
    # def search_big_page(self):
    #     with self.client.post("/house/search?pageSize=30",
    #                           catch_response=True) as response:
    #         if response.status_code != 200:
    #             response.failure("search_big_page: Got wrong response")

    @events.test_start.add_listener
    def on_test_start(environment, **kwargs):
        print("A new test is starting")

    @events.test_stop.add_listener
    def on_test_stop(environment, **kwargs):
        print("A new test is ending")
