require_relative "boot"

require "rails"

require "action_controller/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require "action_mailer/railtie" # Needed for cucumber-rails 2.1.0

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

if !Rails.env.production? || ENV["HEROKU_APP_NAME"].present?
  require "govuk_publishing_components"
end

module Collections
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.time_zone = "London"

    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.yml")]
    config.i18n.fallbacks = true

    config.assets.prefix = "/assets/collections/"

    # allow overriding the asset host with an enironment variable, useful for
    # when router is proxying to this app but asset proxying isn't set up.
    config.asset_host = ENV["ASSET_HOST"]

    # Override Rails 4 default which restricts framing to SAMEORIGIN.
    config.action_dispatch.default_headers = {
      "X-Frame-Options" => "ALLOWALL",
    }

    # Using a sass css compressor causes a scss file to be processed twice
    # (once to build, once to compress) which breaks the usage of "unquote"
    # to use CSS that has same function names as SCSS such as max.
    # https://github.com/alphagov/govuk-frontend/issues/1350
    config.assets.css_compressor = nil

    # As part of the 2020 user discovery into GOV.UK accounts we want
    # to deploy a live prototype allowing Brexit/Transition checker
    # users to persisit their results page.  We'll display a different
    # header on /transition prompting users to return to their
    # account.
    config.feature_flag_govuk_accounts = ENV["FEATURE_FLAG_ACCOUNTS"] == "enabled"
  end
end
