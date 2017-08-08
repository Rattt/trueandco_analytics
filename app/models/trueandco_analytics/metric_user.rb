module TrueandcoAnalytics
  class MetricUser < ApplicationRecord
    self.table_name = 'metric_users'

    has_many :metric_user_visits, dependent: :destroy
    has_many :metric_user_sessions, dependent: :destroy
  end
end
