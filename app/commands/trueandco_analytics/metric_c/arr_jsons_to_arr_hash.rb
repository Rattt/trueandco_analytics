module TrueandcoAnalytics
  module MetricC
    class ArrJsonsToArrHash

      def initialize(arr_json)
        @arr_json = arr_json
      end

      def execute
        result = []
        @arr_json.each do |json|
          result << JSON.parse(json)
        end
        result
      end

      private

      attr_reader :arr_json
    end
  end
end