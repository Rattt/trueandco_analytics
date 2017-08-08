require_dependency "trueandco_analytics/application_report"

module TrueandcoAnalytics
  class DetailsReport < ApplicationReport

    attr_reader :data

    def file_name
      "details-report-#{DateTime.now.strftime("%Y.%m.%d %H:%M")}.#{@format}"
    end

    private

    def source_data(date_start, date_end)
      sql = <<-SQL_TEXT
          SELECT DATE(metric_user_sessions.session_start) as 'date', metric_users.*, metric_user_sessions.*, metric_user_visits.*
          FROM metric_user_visits 
          LEFT JOIN metric_users ON metric_user_visits.metric_user_id = metric_users.id
          LEFT JOIN metric_user_sessions ON metric_user_visits.metric_user_session_id = metric_user_sessions.id
          WHERE DATE(metric_user_sessions.session_start) BETWEEN CAST('#{date_start}' AS DATE) AND CAST('#{date_end}' AS DATE)
          ORDER BY DATE(metric_user_sessions.session_start) DESC, metric_users.id, metric_user_sessions.session_start ASC
      SQL_TEXT
      ActiveRecord::Base.connection.exec_query(sql).to_a
    end
  end
end