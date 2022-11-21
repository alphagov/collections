module ResearchPanelBannerHelper
  SIGNUP_URL = "https://signup.take-part-in-research.service.gov.uk/?utm_campaign=GOV.UK&utm_source=govukhp&utm_medium=gov.uk&t=GDS&id=456".freeze
  RECRUITMENT_PAGES = {
    "/bank-holidays" => SIGNUP_URL,
    "/browse/benefits" => SIGNUP_URL,
    "/browse/births-deaths-marriages/register-offices" => SIGNUP_URL,
    "/browse/disabilities" => SIGNUP_URL,
    "/browse/disabilities/work" => SIGNUP_URL,
    "/browse/driving/driving-licences" => SIGNUP_URL,
  }.freeze

  def signup_url_for(path)
    key = RECRUITMENT_PAGES.keys.find { |topic| path.eql?(topic) }
    RECRUITMENT_PAGES[key]
  end
end
