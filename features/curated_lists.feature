Feature: Curated lists
  In order to see curated content for a subtopic
  As a user with specialist needs
  I can view a curated list of content organized by topic

  Scenario: Viewing curated content for a subtopic
    Given there is curated content for a subtopic
    When I view the browse page for that subtopic
    Then I see a curated list of content
