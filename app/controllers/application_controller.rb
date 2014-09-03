class ApplicationController < ActionController::Base
  include Slimmer::Headers

  protect_from_forgery with: :exception

  before_filter :set_expiry
  before_filter :set_slimmer_template

  private

  def set_slimmer_template
    set_slimmer_headers(template: 'header_footer_only')
  end

  def error_404; error 404; end
  def error_410; error 410; end
  def error_503(e); error(503, e); end

  def error(status_code, exception = nil)
    Airbrake.notify_or_ignore(exception) if exception
    render status: status_code, text: "#{status_code} error"
  end

  def cacheable_404
    set_expiry(10.minutes)
    error 404
  end

  def set_expiry(duration = 30.minutes)
    unless Rails.env.development?
      expires_in(duration, :public => true)
    end
  end

  def validate_slug_param(param_name = :slug)
    param_to_use = params[param_name]
    if param_to_use.parameterize != param_to_use
      cacheable_404
    end
  rescue StandardError # Triggered by trying to parameterize malformed UTF-8
    cacheable_404
  end
end
