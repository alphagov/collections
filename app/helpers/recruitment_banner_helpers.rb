module RecruitmentBannerHelpers
  TOPICS_TO_TEST = %w[
    /browse/benefits/manage-your-benefit
    /browse/benefits/looking-for-work
    /browse/benefits/unable-to-work
    /browse/benefits/families
    /browse/benefits/disability
    /browse/benefits/help-for-carers
    /browse/benefits/low-income
    /browse/benefits/bereavement
    /browse/business/business-tax
    /browse/business/limited-company
    /browse/tax/capital-gains
    /browse/tax/court-claims-debt-bankruptcy
    /browse/tax/dealing-with-hmrc
    /browse/tax/income-tax
    /browse/tax/inheritance-tax
    /browse/tax/national-insurance
    /browse/tax/self-assessment
    /browse/tax/vat
    /topic/dealing-with-hmrc
    /topic/personal-tax/capital-gains-tax
    /topic/dealing-with-hmrc/paying-hmrc
    /topic/dealing-with-hmrc/complaints-appeals
    /topic/dealing-with-hmrc/tax-agent-guidance
    /topic/personal-tax/national-insurance
    /topic/personal-tax/self-assessment
    /topic/business-tax/vat
  ].freeze

  def hide_banner?(path)
    TOPICS_TO_TEST.exclude?(path)
  end
end
