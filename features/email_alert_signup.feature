Feature: Email alert signup
  As an interested person
  In order to get up to date notifications about categorized content
  I want to be able to sign up for email alerts for a topic

  @mock-email-alert-api
  Scenario: signing up for email alerts for a topic
    Given a topic subscription is expected
    When I access the email signup page via the topic
    And I sign up to the email alerts
    Then my subscription should be registered
