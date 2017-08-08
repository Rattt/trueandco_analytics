module TrueandcoAnalytics
  class MetricUserSession < ApplicationRecord
    self.table_name = 'metric_user_sessions'

    has_many :metric_user_visits, dependent: :destroy
    belongs_to :metric_user
  end
end
