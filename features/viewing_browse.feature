Feature: Viewing browse
  As a user
  I want to be able to browse content
  So that I can quickly the content I need

  Scenario: Browse to a browse page
    Given there is a browse page set up with links
    When I visit the main browse page
    Then I see the list of top level browse pages
    When I click on a top level browse page
    Then I see the list of second level browse pages
    When I click on a second level browse page
    Then I should see the second level browse page
    Then I see the links tagged to the browse page
    Then the A to Z label should be present

  Scenario: Browse to a curated browse page
    Given that there are curated second level browse pages
    When I visit the main browse page
    Then I see the list of top level browse pages
    When I click on a top level browse page
    Then I see the curated list of second level browse pages
    Then the A to Z label should not be present

  Scenario: Browse to browse page that has "Detailed guidance"
    Given there is a browse page set up with links
    When I visit that browse page
    Then I should see the topics linked under Detailed guidance
