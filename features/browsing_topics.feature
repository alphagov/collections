Feature: Browsing topics
  In order to see all content relating to my specialist interest
  As a user with specialist needs
  I can view content for my topic broken down by topic

  Scenario: listing organisations for a subtopic
    Given there are documents in a subtopic
    When I view the browse page for that subtopic
    Then I see a list of organisations associated with content in the subtopic
