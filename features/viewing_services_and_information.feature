Feature: Viewing services and information
  In order to see all services and information relating to my chosen organisation
  As a user with specialist needs
  I can view services and information for the organisation broken down by topic

  Scenario: listing links for a topic
    Given there are documents in a topic
    When I view the services and information page for the organisation
    Then I see a list of links associated with content in the topic
