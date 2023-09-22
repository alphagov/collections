module RecruitmentBannerHelper
  BRAND_SURVEY_URL = "https://surveys.publishing.service.gov.uk/s/5G06FO/".freeze

  SURVEY_URL_MAPPINGS = {
    "/browse/births-deaths-marriages/child-adoption" => BRAND_SURVEY_URL,
    "/browse/business/imports" => BRAND_SURVEY_URL,
    "/topic/business-tax/vat" => BRAND_SURVEY_URL,
    "/learn-to-drive-a-car" => BRAND_SURVEY_URL,
  }.freeze

  def recruitment_survey_url
    brand_user_research_test_url
  end

  def brand_user_research_test_url
    SURVEY_URL_MAPPINGS[base_path]
  end
end
