module TrueandcoAnalytics
  module TrueandcoAnalyticsHelper

    def track_user_behavior
      pull_user_statistic_path = Engine.routes.url_helpers.receiver_pull_user_statistic_path
      return unless @user_behavior.nil?
      @user_behavior = 1
      js_string = <<-USER_BEHAVIOR_TRACK
        var statistics_url = "#{root_url.chomp('/')}#{pull_user_statistic_path}",
            app_token = "#{form_authenticity_token}";

        userLog.init(statistics_url, app_token, {

            clickCount: true,
                clickDetails: true,
                actionItem: {
                    processOnAction: true,
                    selector: '.buy',
                    event: 'click'
            },
            processTime: #{Config::Params.time_survey},
                processData: function(results, statistics_url, app_token) {
                var xhr = new XMLHttpRequest();
                xhr.open('POST', statistics_url, true);
                xhr.setRequestHeader('X-CSRF-Token', app_token);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                console.log(results);
                //debugger;
                var data = "user_metric=" + JSON.stringify(results);
                xhr.send(data);
            },
        });
      USER_BEHAVIOR_TRACK
      javascript_tag js_string, defer: 'defer'
    end
  end
end
