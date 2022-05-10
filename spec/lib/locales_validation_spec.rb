RSpec.describe "locales files" do
  it "should meet all locale validation requirements" do
    skip_validation = %w[
      organisations.content_item.schema_name
      roles.heading
      organisations.type
      organisations.works_with_statement
    ]
    checker = RailsTranslationManager::LocaleChecker.new("config/locales/*/*.yml", skip_validation)
    expect(checker.validate_locales).to be_truthy
  end
end
