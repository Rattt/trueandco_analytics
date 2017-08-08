module TrueandcoAnalytics

  class UserSessionMetricWorker
    include Sidekiq::Worker
    sidekiq_options queue: :user_metric

    def perform(*args)
      info_pages = args[0]
      info_request = args[1]

      @redis = RedisConnect.get
      user_session_data_json = @redis.lrange(info_pages, 0, -1)
      return if user_session_data_json.nil?
      user_session_data = MetricC::ArrJsonsToArrHash.new(user_session_data_json).execute
      first_point = user_session_data[0]
      last_point =  user_session_data[-1]
      metric_user = UserC::CreateOrUpdateUserIfExist.new(info_request['user_agent'], last_point['time']['timestamp']).execute
      return if metric_user.nil?
      session = SessionC::Create.new(metric_user, first_point, last_point['time']['timestamp'], info_request).execute
      MetricC::AddList.new(metric_user, session, user_session_data).execute
    end
  end
end
