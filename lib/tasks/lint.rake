desc "Run govuk-lint with similar params to CI"
task lint: :environment do
  unless ENV["JENKINS"]
    sh "bundle exec rubocop --parallel --format clang app spec lib"
  end
end
