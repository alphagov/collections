Rails.application.config.assets.precompile += %w(
  application-ie6.css
  application-ie7.css
  application-ie8.css
  print.css
)

Rails.application.config.assets.prefix = "/collections"

Rails.application.config.assets_version = '1.0'
