require_dependency "trueandco_analytics/application_report"

module TrueandcoAnalytics
  class PageBuyInDateRangeReport < ApplicationReport

    attr_reader :data

    def file_name
      "page-buy-report-#{DateTime.now.strftime("%Y.%m.%d %H:%M")}.#{@format}"
    end

    private

    def source_data(date_start, date_end)
      sql = <<-SQL_TEXT
          SELECT metric_user_visits.page_path, DATE(metric_user_sessions.session_start) as session_start, COUNT(metric_user_visits.metric_user_id) as buy_visit, all_visit.all_visit, group_concat(metric_user_visits.metric_user_id) as user_ids
          FROM metric_user_visits 
          LEFT JOIN metric_user_sessions ON metric_user_visits.metric_user_session_id = metric_user_sessions.id
          LEFT JOIN (SELECT metric_user_visits.page_path, DATE(metric_user_sessions.session_start) as session_start, COUNT(metric_user_visits.metric_user_id) as all_visit
                     FROM  metric_user_visits
                     LEFT JOIN metric_user_sessions ON metric_user_visits.metric_user_session_id = metric_user_sessions.id
                     GROUP BY page_path, DATE(metric_user_sessions.session_start)
                    ) AS all_visit ON metric_user_visits.page_path = all_visit.page_path AND DATE(metric_user_sessions.session_start) = all_visit.session_start
          WHERE metric_user_visits.is_buy = true AND
          DATE(metric_user_sessions.session_start) BETWEEN CAST('#{date_start}' AS DATE) AND CAST('#{date_end}' AS DATE)
          GROUP BY page_path, DATE(metric_user_sessions.session_start)
      SQL_TEXT
      ActiveRecord::Base.connection.exec_query(sql).to_a
    end
  end
end