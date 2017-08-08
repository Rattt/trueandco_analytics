Sidekiq.configure_client do |config|
  config.redis = { namespace: TrueandcoAnalytics::Config::Params.sidekiq_configure_namespace,
    url: TrueandcoAnalytics::Config::Params.sidekiq_configure_client_url }
end
Sidekiq.configure_server do |config|
  config.redis = { namespace: TrueandcoAnalytics::Config::Params.sidekiq_configure_namespace,
    url: TrueandcoAnalytics::Config::Params.sidekiq_configure_server_url }
end