TrueandcoAnalytics.setup do |config|
  # Time survey Analytics seconds
  config.time_survey = 15

  # Specify the method available in the ApplicationController to the receiving user object. Containing id, email.
  config.user_method = 'current_user'

  # Specify css the selector class for the button purchase
  config.buy_selector_class = 'buy'

  # Specify the database where redis will store the statistics for the session user
  config.redis_password = ''
  config.redis_db       = 1

  # Specify Sidekiq config
  config.sidekiq_configure_client_url      = 'redis://localhost:6379/1'
  config.sidekiq_configure_server_url      = 'redis://localhost:6379/1'
  config.sidekiq_configure_namespace       = 'metric'
end
