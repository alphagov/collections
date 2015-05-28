class ActionController::Base
  before_filter proc {
    unless ENV["USE_SLIMMER"] || Capybara.current_driver == Capybara.javascript_driver
      response.headers[Slimmer::Headers::SKIP_HEADER] = "true"
    end
  }
end
