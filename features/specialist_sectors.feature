Feature: Browsing specialist sectors
  In order to see all content relating to my specialist interest
  As a user with specialist needs
  I can view content for my sector broken down by topic

  Scenario: viewing documents in a specialist sub-sector
    Given there are documents in a specialist sub-sector
    When I view the browse page for that sub-sector
    Then I see the specialist sector documents

  Scenario: listing organisations for a specialist sub-sector
    Given there are documents in a specialist sub-sector
    When I view the browse page for that sub-sector
    Then I see a list of organisations associated with content in the sub-sector
