module NavigationAbHelper
  def legacy_navigation_meta_tag(analytics_identifier)
    if analytics_identifier
      "<meta name='govuk:navigation-legacy' content='#{analytics_identifier}'>"
    else
      ''
    end
  end
end
