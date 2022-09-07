class ApplicationController < ActionController::Base
  include AbTests::LevelTwoBrowseAbTestable
  include Slimmer::Template

  helper_method :level_two_browse_variant
  helper_method :page_under_test?
  helper_method :content_item_h

  protect_from_forgery with: :exception

  before_action :set_level_two_browse_response_header_if_level_two_page
  before_action :set_expiry
  before_action :restrict_request_formats

  slimmer_template "gem_layout"

  rescue_from GdsApi::ContentStore::ItemNotFound, with: :error_404
  rescue_from GdsApi::HTTPForbidden, with: :error_403

  if ENV["BASIC_AUTH_USERNAME"]
    http_basic_authenticate_with(
      name: ENV.fetch("BASIC_AUTH_USERNAME"),
      password: ENV.fetch("BASIC_AUTH_PASSWORD"),
    )
  end

  # Allows additional request formats to be enabled.
  #
  # By default, PublicFacingController actions will only respond to HTML requests. To enable
  # additional formats on any given action, use this helper method. For example:
  #
  #   enable_request_formats index: [:atom, :json]
  #
  # That would allow both atom and JSON requests for the :index action to be processed.
  #
  def self.enable_request_formats(options)
    options.each do |action, formats|
      acceptable_formats[action.to_sym] ||= Set.new
      acceptable_formats[action.to_sym] += Array(formats)
    end
  end

  def self.acceptable_formats
    @acceptable_formats ||= {}
  end

private

  def content_item
    @content_item ||= ContentItem.find!(request.path)
  end

  def content_item_h
    @content_item_h ||= content_item.to_hash
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def restrict_request_formats
    unless can_handle_format?(request.format)
      render status: :not_acceptable, plain: "Request format #{request.format} not handled."
    end
  end

  def can_handle_format?(format)
    # Cannot use include? method rubocop suggests due to bug in Rails that means
    # include? in this case will return incorrect results. Therefore disabling rubocop
    # for this line.
    return true if format == Mime[:html] || format == Mime::ALL

    format && self.class.acceptable_formats.fetch(params[:action].to_sym, []).include?(format.to_sym)
  end

  def error_403
    error 403
  end

  def error_404
    error 404
  end

  def error_410
    error 410
  end

  def error_503(exception)
    error(503, exception)
  end

  def error(status_code, exception = nil)
    GovukError.notify(exception) if exception
    render status: status_code, plain: "#{status_code} error"
  end

  def set_expiry(duration = 5.minutes, public_cache: true)
    unless Rails.env.development?
      expires_in(duration, public: public_cache)
    end
  end

  def setup_content_item_and_navigation_helpers(model)
    @content_item = model.content_item.to_hash
  end

  def breadcrumb_content
    render_partial("_breadcrumbs")
  end

  def render_partial(partial_name, locals = {})
    render_to_string(partial_name, formats: [:html], layout: false, locals: locals)
  end

  def set_level_two_browse_response_header_if_level_two_page
    set_level_two_browse_response_header if page_under_test?
  end
end
