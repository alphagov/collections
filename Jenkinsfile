#!/usr/bin/env groovy

node {
  library("govuk@add-brakeman")
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
