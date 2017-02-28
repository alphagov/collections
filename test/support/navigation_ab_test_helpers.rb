module NavigationAbTestHelpers
  def assert_user_journey_stage_tracked_as_finding_page
    assert_select "meta[name='govuk:user-journey-stage'][content='finding']", 1,
      "Expected a Google Analytics meta tag for tracking that the user has visited a navigation page"
  end
end
