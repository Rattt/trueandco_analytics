module TrueandcoAnalytics
  module RedisConnect
    redis_conect = {}
    redis_conect.merge!({ password: Config::Params.redis_password }) if Config::Params.redis_password
    redis_conect.merge!({ db: Config::Params.redis_db }) if Config::Params.redis_db
    
    @redis = Redis.new(redis_conect.merge({ driver: :hiredis }))
    class << self
      def get
        @redis
      end
    end
  end
end