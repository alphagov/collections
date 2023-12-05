module RecruitmentBannerHelper
  SURVEY_URL = "https://surveys.publishing.service.gov.uk/s/ur-ttm/".freeze

  SURVEY_URL_MAPPINGS = {
    "/browse/business/setting-up" => SURVEY_URL,
    "/browse/business/business-tax" => SURVEY_URL,
    "/browse/business/finance-support" => SURVEY_URL,
    "/browse/business/limited-company" => SURVEY_URL,
    "/browse/business/expenses-employee-benefits" => SURVEY_URL,
    "/browse/business/funding-debt" => SURVEY_URL,
    "/browse/business/premises-rates" => SURVEY_URL,
    "/browse/business/food" => SURVEY_URL,
    "/browse/business/imports" => SURVEY_URL,
    "/browse/business/exports" => SURVEY_URL,
    "/browse/business/licences" => SURVEY_URL,
    "/browse/business/selling-closing" => SURVEY_URL,
    "/browse/business/sale-goods-services-data" => SURVEY_URL,
    "/browse/business/childcare-providers" => SURVEY_URL,
    "/browse/business/manufacturing" => SURVEY_URL,
    "/browse/business/intellectual-property" => SURVEY_URL,
    "/browse/business/waste-environment" => SURVEY_URL,
    "/browse/business/science" => SURVEY_URL,
    "/browse/business/maritime" => SURVEY_URL,
    "/browse/business" => SURVEY_URL,
  }.freeze

  def recruitment_survey_url
    user_research_test_url
  end

  def user_research_test_url
    SURVEY_URL_MAPPINGS[base_path]
  end
end
