# Trueandco_analytics
**Trueandco_analytics** Gems for authentication and authorization

## About
Many systems analysts do not provide data about the specific user. This gem allows administrators to obtain reports on a particular user and common page statistics 


## Installation

1. You shall have (redis, sidekiq, mysql) on your server.
2. You have to include gems in your Gemfile:

  ```ruby
  gem 'trueandco_analytics'
  ```

3. And then to start

  ```ruby
  bundle
  ```

4. To start the initialiser, for detailed configured gem
    
   ```ruby
   rails g trueandco_analytics:install
   ```
   
   After
   
   ```ruby
      rake db:migrate 
   ```
   or
   ```ruby
     rails db:migrate
   ```
   That create 3 tables:
   
   `metric_users`, `metric_user_sessions`, `metric_user_visits`
   
   `metric_users`         Info about users
   `metric_user_sessions` Info about user sesssions
   `metric_user_visits`   Pages which were visited by the user within the session
   
   Add assetcs 
   ```js
     //= require trueandco_analytics/application.js
   ```
   
   Add the mointing address
   ```ruby
     mount TrueandcoAnalytics::Engine, at: "/metric"
   ```
   
   
## Usage 

    Now we can take data in a convenient format.
    It is necessary to specify the report and a format of data
    So far only csv is available
    
   ```ruby
    report = TrueandcoAnalytics::PageBuyInDateRangeReport.new(format, datetime_start, datetime_end)
   ```
   
   ```ruby
    report = TrueandcoAnalytics::DetailsReport.new(format, datetime_start, datetime_end)
   ```
   
  
## Settings

  * Time survey Analytics seconds
  `config.time_survey = 15`

  * Specify the method available in the ApplicationController to the receiving user object. Containing id, email.
  `config.user_method = 'current_user'`

  * Specify css the selector class for the button purchase
  `config.buy_selector_class = 'buy'`

  * Specify the database where redis will store the statistics for the session user
  `config.redis_password = ''`
  `config.redis_db       = 1`

  * Specify Sidekiq config
  `config.sidekiq_configure_client_url      = 'redis://localhost:6379/1'`
  `config.sidekiq_configure_server_url      = 'redis://localhost:6379/1'`
  `config.sidekiq_configure_namespace       = 'metric'`


## Ruby version tested

**2.2.4**

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Rattt/zetto. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.