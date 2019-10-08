use Mix.Config

config(:coniglio, :client, Coniglio.RealClient)
config(:coniglio, :broker_url, System.get_env("AMQP_URL", "amqp://guest:guest@localhost:5672"))
