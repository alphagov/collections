module Collections
  def self.services(name, service = nil)
    @services ||= {}

    if service
      @services[name] = service
      return true
    else
      if @services[name]
        return @services[name]
      else
        raise ServiceNotRegisteredException.new(name)
      end
    end
  end

  class ServiceNotRegisteredException < Exception; end
end

require 'gds_api/content_api'
Collections.services(:content_api, GdsApi::ContentApi.new(
  Plek.current.find('contentapi'),
  { web_urls_relative_to: Plek.current.website_root }
))

Collections.services(:detailed_guidance_content_api, GdsApi::ContentApi.new(
  "#{Plek.current.find('whitehall-admin')}/api/specialist"
))

require 'gds_api/email_alert_api'
Collections.services(:email_alert_api, GdsApi::EmailAlertApi.new(Plek.new.find('email-alert-api')))

require 'gds_api/content_store'
Collections.services(:content_store, GdsApi::ContentStore.new(Plek.new.find('content-store')))
