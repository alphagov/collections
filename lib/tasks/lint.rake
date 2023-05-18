desc "Run all linters"
task lint: :environment do
  sh "bundle exec rubocop"
  sh "yarn run lint"
  sh "bundle exec erblint --lint-all"
end
