module TrueandcoAnalytics
  module SessionC
    class Create

      def initialize(metric_user, first_point, timestamp_end, request_info)
        @metric_user = metric_user
        @ip             = request_info['remote_ip']
        @user_agent     = request_info['user_agent']
        @session_start  = first_point['time']['timestamp']
        @referer        = first_point['userReferrer']
        @live_time_s  = timestamp_end - @session_start
      end

      def execute
        Browser::Base.include(Browser::Aliases)
        browser = Browser.new(user_agent, accept_language: "en-us")
        data = {
          metric_user: metric_user,
          user_agent: user_agent,
          referer: referer,
          session_start: datetime_session_start,
          live_time_s: 60,
          ip_4: ip_v4(ip),
          ip_6: ip_v6(ip),
          browser: browser.name,
          is_mobile: browser.mobile? || false
        }
        MetricUserSession.create(data)
      end

      private

      attr_reader :metric_user, :ip, :user_agent, :session_start, :live_time_s, :referer

      def  datetime_session_start
        DateTime.strptime(session_start.to_s,'%s')
      end

      def ip_v4(ip)
        ip_o   = get_ip_object(ip)
        result = 0
        result = ip_o.to_i if ip_o.ipv4?
        result
      end


      def ip_v6(ip)
        ip_o   = get_ip_object(ip)
        result = 0
        result = ip_o.data if ip_o.ipv6?
        result
      end

      def get_ip_object(ip)
        @ip_o ||= IPAddress.parse ip
      end
    end
  end
end