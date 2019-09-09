use Mix.Config

config(:coniglio, Amqp, connection: AMQP.Connection, channel: AMQP.Channel)
