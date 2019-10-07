use Mix.Config

config(:consul, :base_url, "localhost:8500")
import_config "#{Mix.env()}.exs"
