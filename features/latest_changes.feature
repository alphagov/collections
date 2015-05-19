Feature: Browsing latest changes
  In order to see the most recently changed content for a subtopic
  As a user with specialist needs
  I can view a "latest changes" list of content ordered by date

  Scenario: viewing curated content for a subtopic
    Given there is latest content for a subtopic
    When I view the latest changes page for that subtopic
    Then I see a date-ordered list of content with change notes
