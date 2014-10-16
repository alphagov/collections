Feature: Email alert signup
  As an interested person
  In order to get up to date notifications about categorized content
  I want to be able to sign up for email alerts for a topic

  @mock-email-alert-api
  Scenario: signing up for email alerts for a topic
    Given a topic
    When I access the email signup page via the topic
    Then I should see a description of what I'm signing up to
    Then my subscription should be registered
    When I sign up to the email alerts
