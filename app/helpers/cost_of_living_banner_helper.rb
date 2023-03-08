module CostOfLivingBannerHelper
  COST_OF_LIVING_SURVEY_URL = "https://s.userzoom.com/m/MSBDMTQ3MVM0NCAg".freeze

  SURVEY_URL_MAPPINGS = {
    "/cost-of-living" => COST_OF_LIVING_SURVEY_URL,
    "/browse/working/state-pension" => COST_OF_LIVING_SURVEY_URL,
  }.freeze

  def survey_url
    SURVEY_URL_MAPPINGS[base_path]
  end
end
