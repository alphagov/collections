APP_STYLESHEETS = {
  "components/_taxon-list.scss" => "components/_taxon-list.css",
  "components/_topic-list.scss" => "components/_topic-list.css",
  "views/_browse.scss" => "views/_browse.css",
  "views/_bunting.scss" => "views/_bunting.css",
  "views/_covid.scss" => "views/_covid.css",
  "views/_history_people.scss" => "views/_history_people.css",
  "views/_ministers.scss" => "views/_ministers.css",
  "views/_organisation.scss" => "views/_organisation.css",
  "views/_organisations.scss" => "views/_organisations.css",
  "views/_taxons.scss" => "views/_taxons.css",
  "views/_topical_events.scss" => "views/_topical_events.css",
  "views/_topics.scss" => "views/_topics.css",
  "views/_world_index.scss" => "views/_world_index.css",
}.freeze

all_stylesheets = APP_STYLESHEETS.merge(GovukPublishingComponents::Config.all_stylesheets)
Rails.application.config.dartsass.builds = all_stylesheets

Rails.application.config.dartsass.build_options << " --quiet-deps"
