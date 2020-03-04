Feature: Analytics
  In order to understand usage to improve our services
  As a developer
  I want to be able to track user behaviour

  @javascript
  Scenario: Ecommerce tracking
    Given there is an alphabetical browse page set up with links
    When I visit the main browse page
    Then the ecommerce tracking tags are present

  Scenario: Link tracking
    Given there is an alphabetical browse page set up with links
    When I visit the main browse page
    Then the links on the page have tracking attributes
