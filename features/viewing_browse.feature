Feature: Viewing browse
  As a user
  I want to be able to browse content
  So that I can quickly the content I need

  @javascript
  Scenario: Browse to a browse page page with Javascript
    Given there is a browse page set up with links
    And the page also has detailed guidance links
    When I visit the main browse page
    And I click on a top level browse page
    Then I see the list of second level browse pages
    When I click on a second level browse page
    Then I should see the second level browse page
    Then I see the links tagged to the browse page
    And I should see the detailed guidance links

  Scenario: Browse to a browse page page without Javascript
    Given there is a browse page set up with links
    And the page also has detailed guidance links
    When I visit the main browse page
    And I click on a top level browse page
    Then I see the list of second level browse pages
    When I click on a second level browse page
    Then I should see the second level browse page
    Then I see the links tagged to the browse page
    And I should see the detailed guidance links

  Scenario: Browse to browse page that has no detailed guidance
    Given there is a browse page set up with links
    And there is no detailed guidance category tagged to the page
    When I visit the main browse page
    And I click on a top level browse page
    When I click on a second level browse page
    Then I see the links tagged to the browse page
