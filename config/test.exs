use Mix.Config

config(:coniglio, :broker_url, System.get_env("AMQP_URL", "amqp://guest:guest@localhost:5672"))
