require "gds_api/email_alert_api"
require "gds_api/content_store"
require "gds_api/search"

module Services
  def self.email_alert_api
    @email_alert_api ||= GdsApi::EmailAlertApi.new(
      Plek.new.find("email-alert-api"),
      bearer_token: ENV.fetch("EMAIL_ALERT_API_BEARER_TOKEN", "bearer_token"),
    )
  end

  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.new.find("content-store"))
  end

  def self.cached_search(params, metric_key: "search.request_time")
    Rails.cache.fetch(params, expires_in: 5.minutes) do
      GovukStatsd.time(metric_key) do
        search_api.search(params).to_h
      end
    end
  end

  def self.search_api
    @search_api ||= GdsApi.search
  end
end
