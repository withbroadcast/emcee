import Config

config :openai_client,
  api_key: System.fetch_env!("OPENAI_SECRET_KEY"),
  organization: System.fetch_env!("OPENAI_ORG_KEY")
