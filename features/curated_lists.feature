Feature: Browsing subcategories
  In order to see curated content for a specialist sub-sector
  As a user with specialist needs
  I can view a curated list of content organized by topic

  Scenario: viewing curated content for a specialist sub-sector
    Given there is curated content for a specialist sub-sector
    When I view the browse page for that sub-sector
    Then I see a curated list of content
