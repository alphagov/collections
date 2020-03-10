require_relative "boot"

require "action_controller/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

if !Rails.env.production? || ENV["HEROKU_APP_NAME"].present?
  require "govuk_publishing_components"
end

module Collections
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml")]
    config.i18n.fallbacks = true

    config.assets.prefix = "/collections/"

    # Override Rails 4 default which restricts framing to SAMEORIGIN.
    config.action_dispatch.default_headers = {
      "X-Frame-Options" => "ALLOWALL",
    }

    # Custom directories with classes and modules you want to be autoloadable.
    config.eager_load_paths += %W(
      #{config.root}/lib
      #{config.root}/app/presenters/supergroups
    )
  end
end
