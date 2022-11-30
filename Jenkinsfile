#!/usr/bin/env groovy

library("govuk")

node {
  govuk.buildProject(
    brakeman: true,
    overrideTestTask: { sh("bundle exec rake lint cucumber spec jasmine") }
  )
}
