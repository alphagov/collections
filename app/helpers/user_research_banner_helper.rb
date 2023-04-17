module UserResearchBannerHelper
  COST_OF_LIVING_SURVEY_URL = "https://gdsuserresearch.optimalworkshop.com/treejack/ct80d1d6".freeze

  SURVEY_URL_MAPPINGS = {
    "/browse/working/state-pension" => COST_OF_LIVING_SURVEY_URL,
  }.freeze

  def survey_url
    SURVEY_URL_MAPPINGS[base_path]
  end
end
