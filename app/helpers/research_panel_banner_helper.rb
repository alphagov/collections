module ResearchPanelBannerHelper
  UR_COMMUNITY_SIGNUP_URL = "https://signup.take-part-in-research.service.gov.uk/?utm_campaign=GOV.UK&utm_source=govukhp&utm_medium=gov.uk&t=GDS&id=456".freeze
  SURVEY_URL_MAPPINGS = {
    "/browse/benefits" => UR_COMMUNITY_SIGNUP_URL,
    "/browse/births-deaths-marriages/register-offices" => UR_COMMUNITY_SIGNUP_URL,
    "/browse/disabilities" => UR_COMMUNITY_SIGNUP_URL,
    "/browse/disabilities/work" => UR_COMMUNITY_SIGNUP_URL,
    "/browse/driving/driving-licences" => UR_COMMUNITY_SIGNUP_URL,
  }.freeze

  def recruitment_survey_url
    ur_community_signup_url
  end

  def ur_community_signup_url
    key = SURVEY_URL_MAPPINGS.keys.find { |topic| base_path.eql?(topic) }
    SURVEY_URL_MAPPINGS[key]
  end
end
