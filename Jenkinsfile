#!/usr/bin/env groovy

library("govuk")

node {
  govuk.buildProject(
    brakeman: true,
    // Run rake default tasks except for pact:verify as that is ran via
    // a separate GitHub action.
    overrideTestTask: { sh("bundle exec rake lint cucumber spec jasmine") }
  )
}
