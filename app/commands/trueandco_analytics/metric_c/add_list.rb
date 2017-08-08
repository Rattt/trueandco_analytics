module TrueandcoAnalytics
  module MetricC
    class AddList

      def initialize(metric_user, session, user_session_data)
        @metric_user    = metric_user
        @session        = session
        @user_session_data = user_session_data
      end

      def execute
        uniq_pages = info_uniq_page
        return if uniq_pages.nil?
        uniq_pages.each do |page|
          data = {
            metric_user: metric_user,
            metric_user_session: session,
            page_path:  page['page_path'],
            user_action: page['clicks']['clickDetails'].to_json,
            time_s: page['time']['timeOnPage'],
            is_buy: page['clicks']['clickDetails'].length > 0
          }
          MetricUserVisit.create(data)
        end
      end

      private

      attr_reader :metric_user, :session, :user_session_data

      def info_uniq_page
        length = user_session_data.length
        return user_session_data if length < 2
        results = []
        page = user_session_data[0]['page_path']
        clickDetails = []
        index = 0
        while index < length - 1
          unless user_session_data[index]['clicks']['clickDetails'].empty?
            clickDetails = user_session_data[index]['clicks']['clickDetails']
          end
          index += 1
          unless page  == user_session_data[index]['page_path']
            data = user_session_data[index - 1]
            data['clicks']['clickDetails'] = clickDetails
            results << data
            page = user_session_data[index]['page_path']
            clickDetails = []
          end
        end
        data = user_session_data[index]
        unless data['clicks']['clickDetails'].empty?
          clickDetails = data['clicks']['clickDetails']
        end
        data['clicks']['clickDetails'] = clickDetails
        results << data
        results
      end
    end
  end
end