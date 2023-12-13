module BrowseHelper
  ACTION_LINK_DATA = {
    benefits: [
      { lang: "browse.check_benefits_and_financial_support", href: "/check-benefits-financial-support" },
    ],
    business: [
      { lang: "browse.hmrc_online_services", href: "/log-in-register-hmrc-online-services" },
      { lang: "browse.self_assessment_tax_returns", href: "/self-assessment-tax-returns" },
      { lang: "browse.pay_employers_paye", href: "/pay-paye-tax" },
    ],
  }.freeze

  def display_action_links_for_slug?(slug)
    ACTION_LINK_DATA.key?(slug.to_sym)
  end

  def action_link_data(slug)
    links = ACTION_LINK_DATA[slug.to_sym]
    return [] unless links

    links.each_with_index do |link, index|
      link[:text] = I18n.t(link[:lang])
      link[:ga4_text] = I18n.t(link[:lang], locale: :en)
      link[:index_link] = index + 1
      link[:index_total] = links.length
    end
  end
end
