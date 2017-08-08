module TrueandcoAnalytics
  module SessionC
    class PutData

      def initialize(json_data, request_info, userInfo)
        @json_data = json_data
        @userInfo = userInfo
        @request_info = request_info
        @redis = RedisConnect.get
        @time_survey = Config::Params.time_survey
        @time_dead_session = Config::Params.time_dead_session
      end

      def execute
        1.times do
          break if userInfo.nil? || userInfo.empty?
          user_key = ::FNV.new.fnv1_32 userInfo.to_s
          mange_job(user_key)
          redis.rpush(user_key, json_data)
          redis.expire(user_key, time_dead_session)
        end
      end

      private

      attr_reader :json_data, :userInfo, :request_info, :redis, :time_dead_session, :time_survey

      def mange_job(user_key)
        user_job_key = "#{user_key}:job_key"
        unless redis.exists user_job_key
          create_job(user_key, user_job_key)
        end
        if redis.ttl(user_job_key) < time_survey * 3
          job_id = redis.get(user_job_key)
          Sidekiq::ScheduledSet.new.find_job(job_id)&.delete
          create_job(user_key, user_job_key)
        end
      end

      def create_job(user_key, user_job_key)
        job_id = UserSessionMetricWorker.perform_at(time_dead_session.seconds.from_now, user_key, request_info)
        redis.setex(user_job_key, time_dead_session, job_id)
      end
    end
  end
end