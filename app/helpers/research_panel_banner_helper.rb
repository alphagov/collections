module ResearchPanelBannerHelper
  UR_COMMUNITY_SIGNUP_URL = "https://signup.take-part-in-research.service.gov.uk/?utm_campaign=GOV.UK&utm_source=govukhp&utm_medium=gov.uk&t=GDS&id=456".freeze
  COST_OF_LIVING_SURVEY_URL = "https://GDSUserResearch.optimalworkshop.com/treejack/cbd7a696cbf57c683cbb2e95b4a36c8a".freeze

  SURVEY_URL_MAPPINGS = {
    "/browse/benefits" => UR_COMMUNITY_SIGNUP_URL,
    "/browse/births-deaths-marriages/register-offices" => UR_COMMUNITY_SIGNUP_URL,
    "/browse/disabilities" => UR_COMMUNITY_SIGNUP_URL,
    "/browse/disabilities/work" => UR_COMMUNITY_SIGNUP_URL,
    "/browse/driving/driving-licences" => UR_COMMUNITY_SIGNUP_URL,
    "/cost-of-living" => COST_OF_LIVING_SURVEY_URL,
  }.freeze

  def recruitment_survey_url
    ur_community_signup_url || cost_of_living_test_url
  end

  def ur_community_signup_url
    key = SURVEY_URL_MAPPINGS.keys.find { |topic| base_path.eql?(topic) }
    SURVEY_URL_MAPPINGS[key]
  end

  def cost_of_living_test_url
    SURVEY_URL_MAPPINGS[base_path]
  end
end
