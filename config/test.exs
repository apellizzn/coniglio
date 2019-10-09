use Mix.Config

config(:coniglio, :broker_url, System.get_env("BROKER_URL", "amqp://guest:guest@localhost:5672"))
