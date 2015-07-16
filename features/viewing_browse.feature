Feature: Viewing browse
  As a user
  I want to be able to browse content
  So that I can quickly the content I need

  @javascript
  Scenario: Browse to a browse page with Javascript
    Given there is an alphabetical browse page set up with links
    When I visit the main browse page
    And I click on a top level browse page
    Then I see the list of second level browse pages
    When I click on a second level browse page
    Then I should see the second level browse page
    Then I see the links tagged to the browse page

  Scenario: Browse to a browse page without Javascript
    Given there is an alphabetical browse page set up with links
    When I visit the main browse page
    And I click on a top level browse page
    Then I see the list of second level browse pages
    When I click on a second level browse page
    Then I should see the second level browse page
    Then I see the links tagged to the browse page

  Scenario Outline: Browse to browse page and look for the A to Z label
    Given there is a <child ordering> browse page set up with links
    When I visit the main browse page
    And I click on a top level browse page
    Then the A to Z label should be <label presence>

    Examples:
      | child ordering | label presence |
      |   alphabetical |        present |
      |        curated |    not present |

  Scenario: Browse to browse page that has "Detailed guidance"
    Given there is an alphabetical browse page set up with links
    When I visit that browse page
    Then I should see the topics linked under Detailed guidance
