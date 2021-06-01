import Config

if System.get_env("HEROKU_APP_NAME") == "edukator" do
  config :edukator, Edukator.Mailer,
    adapter: Swoosh.Adapters.AmazonSES,
    region: System.get_env("AWS_SES_REGION") || raise("missing AWS SES variable AWS_SES_REGION"),
    access_key:
      System.get_env("AWS_SES_ACCESS_KEY_ID") ||
        raise("missing AWS SES variable AWS_SES_ACCESS_KEY_ID"),
    secret:
      System.get_env("AWS_SES_SECRET_ACCESS_KEY") ||
        raise("missing AWS SES variable AWS_SES_SECRET_ACCESS_KEY")
else
  config :edukator, Edukator.Mailer,
    adapter: Swoosh.Adapters.SMTP,
    relay: System.get_env("SMTP_SERVER") || raise("missing variable SMTP_SERVER"),
    username: System.get_env("SMTP_USERNAME") || raise("missing variable SMTP_USERNAME"),
    password: System.get_env("SMTP_PASSWORD") || raise("missing variable SMTP_PASSWORD"),
    port: System.get_env("SMTP_PORT") || raise("missing variable SMTP_PORT"),
    ssl: true,
    tls: :always,
    auth: :always
end
