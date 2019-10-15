Rails.application.config.assets.precompile += %w( manifest.js )

Rails.application.config.assets.precompile += %w(
  application.js
  application.css
  print.css
)

Rails.application.config.assets.prefix = "/collections"

Rails.application.config.assets_version = "1.0"
