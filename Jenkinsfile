#!/usr/bin/env groovy

library("govuk")

node {
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-collections")
  govuk.buildProject(
    beforeTest: { sh("yarn install") },
    publishingE2ETests: true,
    sassLint: false,
    brakeman: true,
  )
}
