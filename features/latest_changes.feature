Feature: Browsing latest changes
  In order to see the most recently changed content for a topic (specialist sub-sector)
  As a user with specialist needs
  I can view a "latest changes" list of content ordered by date

  Scenario: viewing curated content for a specialist sub-sector
    Given there is latest content for a specialist sub-sector
    When I view the latest changes page for that sub-sector
    Then I see a date-ordered list of content with change notes
