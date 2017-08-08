module TrueandcoAnalytics
  module Config
    module Params

      @time_survey                       = 15
      @time_survey_check                 = false
      @time_dead_session                 = 600
      @user_method_check                 = false
      @buy_selector_class                = 'buy'
      @buy_selector_class_check          = false
      @redis_password                    = nil
      @redis_password_check              = false
      @redis_db                          = 1
      @redis_db_check                    = false
      @sidekiq_configure_client_url      = 'redis://localhost:6379/1'
      @sidekiq_configure_client_check    = false
      @sidekiq_configure_server_url      = 'redis://localhost:6379/1'
      @sidekiq_configure_server_check    = false
      @sidekiq_configure_namespace       = 'metric'
      @sidekiq_configure_namespace_check = false

      class << self
        def set_params
          yield self  if block_given?
        end

        def self.attr_writer_only_once(*args)
          args.each do |arg|
            self.send(:define_method, "#{arg}=".intern) do |value|
              instance_variable_set("@#{arg}", value) unless instance_variable_get("@#{arg}_check")
              instance_variable_set("@#{arg}_check", true)
            end
          end
        end

        attr_reader :time_survey, :time_dead_session, :buy_selector_class, :redis_db, :redis_password,
          :sidekiq_configure_client_url, :sidekiq_configure_server_url, :sidekiq_configure_namespace
        
        attr_writer_only_once :time_survey, :user_method, :redis_db, :redis_password, 
          :sidekiq_configure_client_url, :sidekiq_configure_server_url, :sidekiq_configure_namespace

        def buy_selector_class=(value)
          @buy_selector_class = value.delete('.') unless @buy_selector_class_check
          @buy_selector_class_check = true
        end

        def user_method
          return nil unless @user_method_check
          ::ApplicationController.new.public_send(@user_method)
        end
      end
    end
  end
end