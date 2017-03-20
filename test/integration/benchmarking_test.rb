require 'integration_test_helper'
require 'slimmer/test_helpers/govuk_components'

class BenchmarkingTest < ActionDispatch::IntegrationTest
  include RummagerHelpers
  include TaxonHelpers
  include Slimmer::TestHelpers::GovukComponents
  include GovukAbTesting::MinitestHelpers

  before do
    @existing_framework = GovukAbTesting.configuration.acceptance_test_framework

    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = :capybara
    end
  end

  after do
    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = @existing_framework
    end
  end

  it 'shows the mouseflow tag when on the benchmarking test' do
    when_i_am_on_the_new_benchmarking_test
    and_there_is_a_taxon
    when_i_visit_the_taxon_page
    then_there_is_a_mouseflow_tag_on_the_page
    and_the_page_has_been_cached_by_variant
  end

  it 'does not show the mouseflow tag when outside of the benchmarking test' do
    when_i_am_not_on_the_new_benchmarking_test
    and_there_is_a_taxon
    when_i_visit_the_taxon_page
    then_there_is_no_mouseflow_tag_on_the_page
    and_the_page_has_been_cached_by_variant
  end

  def when_i_am_on_the_new_benchmarking_test
    setup_ab_variant('Benchmarking', 'B')
  end

  def when_i_am_not_on_the_new_benchmarking_test
    setup_ab_variant('Benchmarking', 'A')
  end

  def when_i_visit_the_taxon_page
    visit @base_path
  end

  def then_there_is_a_mouseflow_tag_on_the_page
    all_script_tags = page.all('script', visible: false)

    mouseflow_tags =
      all_script_tags.select { |tag| tag[:src].match(/mouseflow-.*\.js/i) }

    assert_equal(
      1,
      mouseflow_tags.count,
      "Expected to find one script tag with the mouseflow js code on the page"
    )
  end

  def and_the_page_has_been_cached_by_variant
    assert_response_is_cached_by_variant('Benchmarking')
  end

  def then_there_is_no_mouseflow_tag_on_the_page
    all_script_tags = page.all('script', visible: false)

    mouseflow_tags =
      all_script_tags.select { |tag| tag[:src].match(/mouseflow-.*\.js/i) }

    assert_equal(
      0,
      mouseflow_tags.count,
      "Did not expect to find a script tag with the mouseflow javascript code"
    )
  end

  def and_there_is_a_taxon
    @base_path = '/education/student-finance'

    student_finance_taxon = student_finance_taxon(
      base_path: @base_path,
      links: {
        parent_taxons: [],
        child_taxons: []
      }
    )

    content_store_has_item(@base_path, student_finance_taxon)

    @taxon = Taxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, [])
  end
end
