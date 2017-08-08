module TrueandcoAnalytics
  class ApplicationReport

    AVAILABLE_FORMATS = %w(csv).freeze

    def initialize(format, date_start = nil, date_end = nil)
      @format = format
      return unless format_available?
      @date_start = date_start.kind_of?(DateTime) ? date_start : DateTime.new(1970,1,1,0,0,0)
      @date_end   = date_end.kind_of?(DateTime) ? date_end : DateTime.now
      arr = source_data(@date_start, @date_end)

      @data = send("to_#{format}", arr)
    end

    def self.formats
      AVAILABLE_FORMATS
    end

    private

    attr_reader :format, :data

    def format_available?
      AVAILABLE_FORMATS.include?(format)
    end

    def to_csv(arr)
      return unless arr.kind_of?(Array)
      return if arr.empty?
      ::CSV.generate do |csv|
        csv << arr.first.keys
        arr.each do |hash|
          csv << hash.values
        end
      end
    end
  end
end