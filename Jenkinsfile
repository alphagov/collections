#!/usr/bin/env groovy

library("govuk@add-brakeman")

node {
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-collections")

  govuk.buildProject(
    overrideTestTask: {
      stage("Run tests") {
        govuk.runTests()
      }

      stage("Run Javascript tests") {
        govuk.runRakeTask("spec:javascript")
      }
    },
    publishingE2ETests: true
  )
}
