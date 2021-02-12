#!/usr/bin/env groovy

library("govuk")

node {
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-collections")
  govuk.buildProject(
    publishingE2ETests: true,
    brakeman: true,
    extraParameters: [
      stringParam(
        name: "GDS_API_PACT_BRANCH",
        defaultValue: "master",
        description: "The branch of gds-api-adapters pact tests to run against"
      ),
    ],
    beforeTest: {
      govuk.setEnvar("PACT_BROKER_BASE_URL", "https://pact-broker.cloudapps.digital")
    },
    afterTest : {
      stage("Verify pact with gds-api-adapters") {
        govuk.runRakeTask("pact:verify:branch[${env.GDS_API_PACT_BRANCH}]")
      }
    }
  )
}
