#!/usr/bin/env groovy

library("govuk")

node {
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-collections")
  govuk.buildProject(
    beforeTest: { sh("yarn install") },
    overrideTestTask: {
      stage("Run tests") {
        govuk.runTests()
      }

      stage("Run Javascript tests") {
        govuk.runRakeTask("jasmine:ci")
      }
    },
    publishingE2ETests: true,
    brakeman: true,
  )
}
