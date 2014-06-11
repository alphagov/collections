Feature: Viewing browse
  As a user
  I want to be able to browse content by sections
  So that I can quickly the content I need

  Scenario: Browse to an aftefact
    Given there is an artefact tagged to a subsection
    And there is a detailed guidance category tagged to a subsection
    When I browse to the subsection
    Then I see the artefact listed
    And I see the detailed guidance category listed

  Scenario: Browse to sub section without detailed guidance
    Given there is an artefact tagged to a subsection
    And there is no detailed guidance category tagged to the subsection
    When I browse to the subsection
    Then I see the artefact listed

