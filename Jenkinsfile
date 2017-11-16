#!/usr/bin/env groovy

node {
  def govuk = load '/var/lib/jenkins/groovy_scripts/govuk_jenkinslib.groovy'
  govuk.buildProject(overrideTestTask: {
    stage("Run tests") {
      govuk.runTests()
    }

    stage("Run Javascript tests") {
      govuk.runRakeTask("spec:javascript")
    }
  })
  govuk.setEnvar("PUBLISHING_E2E_TESTS_COMMAND", "test-collections-publisher")
  govuk.buildProject(publishingE2ETests: true)
}
