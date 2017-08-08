require 'sidekiq/api'
require 'sidekiq'
require 'ipaddress'
require 'csv'
require 'browser'
require 'browser/aliases'
require 'trueandco_analytics/engine'
require 'trueandco_analytics/config/params'

module TrueandcoAnalytics

  def self.table_name_prefix
    'metric_'
  end

  def self.setup(&block)
    TrueandcoAnalytics::Config::Params.set_params(&block)
  end

end
