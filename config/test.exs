use Mix.Config

IO.puts("mix test started with folliwing configuration")
IO.inspect(System.get_env())
config(:coniglio, :broker_url, System.get_env("AMQP_URL") || "amqp://localhost:5672")
config(:coniglio, :client, Coniglio.RabbitClient.RealClient)
