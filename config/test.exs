use Mix.Config

config(:coniglio, Amqp,
  connection: FakeAmqp.Connection,
  channel: FakeAmqp.Channel
)
