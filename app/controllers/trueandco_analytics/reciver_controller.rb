require_dependency "trueandco_analytics/application_controller"

module TrueandcoAnalytics
  class ReceiverController < ApplicationController
    
    def pull_user_statistic
      data = JSON.parse(params[:user_metric])
      userInfo = request.user_agent
      page_path = request.url.match(/(?:\/\/.+?\/)(.+?)(?=\?|$)/)[1]
      data = data.merge({page_path: page_path}).to_json
      request_info = {
        'remote_ip'  => request.remote_ip,
        'user_agent' => request.user_agent
      }


      SessionC::PutData.new(data, request_info, userInfo).execute
      render nothing: true, status: 201, content_type: 'text/plain'
    end
  end
end
