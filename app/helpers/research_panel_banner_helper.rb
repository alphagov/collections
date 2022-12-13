module ResearchPanelBannerHelper
  SIGNUP_URL = "https://signup.take-part-in-research.service.gov.uk/?utm_campaign=GOV.UK&utm_source=govukhp&utm_medium=gov.uk&t=GDS&id=456".freeze
  RECRUITMENT_PAGES = {
    "/browse/benefits" => SIGNUP_URL,
    "/browse/births-deaths-marriages/register-offices" => SIGNUP_URL,
    "/browse/disabilities" => SIGNUP_URL,
    "/browse/disabilities/work" => SIGNUP_URL,
    "/browse/driving/driving-licences" => SIGNUP_URL,
  }.freeze

  def recruitment_survey_url
    signup_url
  end

  def signup_url
    key = RECRUITMENT_PAGES.keys.find { |topic| base_path.eql?(topic) }
    RECRUITMENT_PAGES[key]
  end
end
