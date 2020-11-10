#!/usr/bin/env groovy

library("govuk")

node {
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-collections")
  govuk.buildProject(
    beforeTest: {
      stage("Install node dependencies") {
        sh("yarn")
      }
    },
    overrideTestTask: {
      stage("Lint") {
        sh("bundle exec rake lint")
      }

      stage("Run tests") {
        govuk.runTests()
      }

      stage("Run Javascript tests") {
        govuk.runRakeTask("jasmine:ci")
      }
    },
    publishingE2ETests: true,
    rubyLintDiff: false,
    brakeman: true,
  )
}
