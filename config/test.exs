use Mix.Config

config(:coniglio, :broker_url, System.get_env("AMQP_URL") || "amqp://localhost:5672")
config(:coniglio, :client, Coniglio.RabbitClient.RealClient)
