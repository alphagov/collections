require 'gds_api/email_alert_api'
require 'gds_api/content_store'
require 'gds_api/rummager'

module Services
  def self.email_alert_api
    @email_alert_api ||= GdsApi::EmailAlertApi.new(
      Plek.new.find('email-alert-api'),
      bearer_token: ENV.fetch("EMAIL_ALERT_API_BEARER_TOKEN", "bearer_token")
    )
  end

  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.new.find('content-store'))
  end

  def self.rummager
    @rummager ||= GdsApi::Rummager.new(Plek.new.find("search"))
  end
end
