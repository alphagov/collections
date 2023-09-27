module RecruitmentBannerHelper
  SURVERY_URL = "https://surveys.publishing.service.gov.uk/s/SNFVW1/".freeze

  SURVEY_URL_MAPPINGS = {
    "/browse/tax" => SURVERY_URL,
    "/browse/tax/self-assessment" => SURVERY_URL,
    "/topic/personal-tax/self-assessment" => SURVERY_URL,
  }.freeze

  def recruitment_survey_url
    user_research_test_url
  end

  def user_research_test_url
    SURVEY_URL_MAPPINGS[base_path]
  end
end
