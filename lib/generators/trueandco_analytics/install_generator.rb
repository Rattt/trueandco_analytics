require 'rails/generators'
module TrueandcoAnalytics
  class InstallGenerator < Rails::Generators::Base
    desc "Configuration UserMetrix gem"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_initializer
      template 'trueandco_analytics.rb', 'config/initializers/trueandco_analytics.rb'
    end
  end
end
