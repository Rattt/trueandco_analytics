module TrueandcoAnalytics
  module UserC
    class CreateOrUpdateUserIfExist

      def initialize(user_agent, timestamp_end)
        @user_agent = user_agent
        @timestamp_end = timestamp_end
        @user_id = Config::Params.user_method&.id
      end

      def execute
        user = nil
        user = TrueandcoAnalytics::MetricUser.find_by(user_id: user_id) if user_id
        user = TrueandcoAnalytics::MetricUser.find_by(hash_id: hash_id) if user.nil?
        user = if user.nil?
                 TrueandcoAnalytics::MetricUser.create(user_id: user_id, datetime_create: datetime_end,
                   last_active_datetime: datetime_end, hash_id: hash_id)
               else
                 user.update_attribute(:last_active_datetime, datetime_end)
                 user
               end
        user
      end

      private

      attr_reader :user_agent, :timestamp_end, :user_id

      def  datetime_end
        DateTime.strptime(timestamp_end.to_s,'%s')
      end

      def hash_id
        @hash_id ||= FNV.new.fnv1_32(user_agent)
      end
    end
  end
end
