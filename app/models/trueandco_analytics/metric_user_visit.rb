module TrueandcoAnalytics
  class MetricUserVisit < ApplicationRecord
    self.table_name = 'metric_user_visits'

    belongs_to :metric_user_session
    belongs_to :metric_user
  end
end