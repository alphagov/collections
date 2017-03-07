require 'integration_test_helper'
require 'slimmer/test_helpers/govuk_components'

class TaxonBrowsingTest < ActionDispatch::IntegrationTest
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

  it 'is possible to browse a taxon page that has grandchildren' do
    given_there_is_a_taxon_with_grandchildren
    when_i_visit_the_taxon_page
    then_i_can_see_there_is_a_page_title
    then_i_can_see_the_breadcrumbs
    and_i_can_see_the_title_and_description
    and_i_can_see_links_to_the_child_taxons_in_a_grid
    and_the_grid_has_tracking_attributes
    and_i_can_see_tagged_content_to_the_taxon
    and_the_content_tagged_to_the_grandfather_taxon_has_tracking_attributes
    and_the_page_is_tracked_as_a_grid
  end

  it 'is possible to browse a taxon page that does not have grandchildren' do
    given_there_is_a_taxon_without_grandchildren
    when_i_visit_the_taxon_page
    then_i_can_see_there_is_a_page_title
    then_i_can_see_the_breadcrumbs
    and_i_can_see_the_title_and_description
    and_i_can_see_the_overview_section_in_the_accordion
    and_i_can_see_links_to_the_child_taxons_in_an_accordion
    and_the_accordion_has_tracking_attributes
    and_i_can_see_tagged_content_to_the_taxon
    and_the_page_is_tracked_as_an_accordion
  end

  it 'does not show the overview section when there is no content tagged' do
    given_there_is_a_taxon_without_grandchildren
    and_the_taxon_has_no_tagged_content
    when_i_visit_the_taxon_page
    then_there_is_no_overview_section_in_the_accordion
  end

  it 'is possible to browse a taxon page that does not have child taxons' do
    given_there_is_a_taxon_without_child_taxons
    when_i_visit_the_taxon_page
    then_i_can_see_there_is_a_page_title
    then_i_can_see_the_breadcrumbs
    and_i_can_see_the_title_and_description
    and_i_can_see_tagged_content_to_the_taxon
    and_the_content_tagged_to_the_leaf_taxon_has_tracking_attributes
    and_the_page_is_tracked_as_a_leaf_node_taxon
  end

private

  def search_results
    [
      {
        'title' => 'Content item 1',
        'description' => 'Description of content item 1',
        'link' => 'content-item-1'
      },
      {
        'title' => 'Content item 2',
        'description' => 'Description of content item 2',
        'link' => 'content-item-2'
      },
    ]
  end

  def given_there_is_a_taxon_with_grandchildren
    @base_path = '/education/funding_and_finance_for_students'
    funding_and_finance_for_students_taxon =
      funding_and_finance_for_students_taxon(base_path: @base_path)

    @parent =
      funding_and_finance_for_students_taxon['links']['parent_taxons'].first
    assert_not_nil @parent

    @child_taxons =
      funding_and_finance_for_students_taxon['links']['child_taxons']
    assert @child_taxons.length > 0

    content_store_has_item(@base_path, funding_and_finance_for_students_taxon)
    content_store_has_item(
      student_finance_taxon['base_path'],
      student_finance_taxon
    )
    content_store_has_item(
      student_sponsorship_taxon['base_path'],
      student_sponsorship_taxon
    )
    content_store_has_item(
      student_loans_taxon['base_path'],
      student_loans_taxon
    )

    @taxon = Taxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results)
    stub_content_for_taxon(student_finance_taxon['content_id'], search_results)
    stub_content_for_taxon(student_sponsorship_taxon['content_id'], search_results)
    stub_content_for_taxon(student_loans_taxon['content_id'], search_results)
  end

  def given_there_is_a_taxon_without_grandchildren
    @base_path = '/education/student-finance'
    student_finance = student_finance_taxon(base_path: @base_path)

    @parent = student_finance['links']['parent_taxons'].first
    assert_not_nil @parent

    @child_taxons = student_finance['links']['child_taxons']
    assert @child_taxons.length > 0

    content_store_has_item(@base_path, student_finance)
    content_store_has_item(
      student_sponsorship_taxon['base_path'],
      student_sponsorship_taxon
    )
    content_store_has_item(
      student_loans_taxon['base_path'],
      student_loans_taxon
    )

    @taxon = Taxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results)
    stub_content_for_taxon(student_sponsorship_taxon['content_id'], search_results)
    stub_content_for_taxon(student_loans_taxon['content_id'], search_results)
  end

  def and_the_taxon_has_no_tagged_content
    stub_content_for_taxon(@taxon.content_id, [])
  end

  def given_there_is_a_taxon_without_child_taxons
    @base_path = '/education/running-a-further-or-higher-education-institution'
    running_an_institution = running_an_education_institution_taxon(base_path: @base_path)

    @parent = running_an_institution['links']['parent_taxons'].first
    assert_not_nil @parent

    assert_nil running_an_institution['links']['child_taxons']

    content_store_has_item(@base_path, running_an_institution)

    @taxon = Taxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results)
  end

  def when_i_visit_the_taxon_page
    with_B_variant do
      visit @base_path
    end
  end

  def then_i_can_see_there_is_a_page_title
    assert page.has_selector?(
      'title',
      text: @taxon.title,
      visible: false
    )
  end

  def then_i_can_see_the_breadcrumbs
    assert_not_nil shared_component_selector('breadcrumbs')
  end

  def and_i_can_see_the_title_and_description
    assert page.has_content?(@taxon.title)
    assert page.has_content?(@taxon.description)
  end

  def and_i_can_see_links_to_the_child_taxons_in_a_grid
    assert page.has_selector?('nav.child-topics-list')

    @child_taxons.each do |child_taxon|
      assert page.has_link?(child_taxon['title'], child_taxon['base_path'])
      assert page.has_content?(child_taxon['description'])
    end
  end

  def and_the_grid_has_tracking_attributes
    tracked_links = page.all(:css, "a[data-track-category='navGridLinkClicked']")
    tracked_links.size.must_equal @child_taxons.size

    tracked_links.each_with_index do |link, index|
      expected_tracking_options = {
        dimension28: @child_taxons.size.to_s,
        dimension29: @child_taxons[index]['title']
      }

      link[:'data-track-action'].must_equal "#{index + 1}"
      link[:'data-track-label'].must_equal @child_taxons[index]['base_path']
      link[:'data-track-options'].must_equal expected_tracking_options.to_json
      link[:'data-module'].must_equal 'track-click'
    end

    # Test an example free from logic
    assert page.has_css?(
      "a[data-track-category='navGridLinkClicked']" +
      "[data-track-action='1']" +
      "[data-track-label='/education-training-and-skills/student-finance']" +
      "[data-track-options='{\"dimension28\":\"1\",\"dimension29\":\"Student finance\"}']" +
      "[data-module='track-click']"
    )
  end

  def and_i_can_see_links_to_the_child_taxons_in_an_accordion
    assert page.has_selector?('.child-topic-contents')

    @child_taxons.each do |child_taxon|
      assert page.has_content?(child_taxon['title'])
      assert page.has_content?(child_taxon['description'])
    end
  end

  def and_i_can_see_the_overview_section_in_the_accordion
    subsection = first('.subsection')

    assert subsection.has_selector?('.subsection-title', text: /overview/i)
    assert subsection.has_selector?(
      '.subsection-content .subsection-list-item a',
      count: 2
    )
  end

  def then_there_is_no_overview_section_in_the_accordion
    subsection = first('.subsection')

    assert_equal(
      false,
      subsection.has_selector?('.subsection-title', text: /overview/i)
    )
  end

  def and_the_accordion_has_tracking_attributes
    tracked_links = page.all(:css, "a[data-track-category='navAccordionLinkClicked']")
    tracked_links.size.must_equal(
      (@child_taxons.size * search_results.size) + ([@taxon].size * search_results.size)
    )

    tracked_links.each_with_index do |link, index|
      section_number = (index / search_results.size).floor + 1
      item_number = index % search_results.size + 1

      expected_tracking_options = {
        dimension28: search_results.size.to_s,
        dimension29: search_results[item_number - 1]['title']
      }

      link[:'data-track-action'].must_equal "#{section_number}.#{item_number}"
      link[:'data-track-label'].must_equal "#{search_results[item_number - 1]['link']}"
      link[:'data-track-options'].must_equal expected_tracking_options.to_json
      link[:'data-module'].must_equal 'track-click'
    end

    # Test an example free from logic
    assert page.has_css?(
      "a[data-track-category='navAccordionLinkClicked']" +
      "[data-track-action='2.2']" +
      "[data-track-label='content-item-2']" +
      "[data-track-options='{\"dimension28\":\"2\",\"dimension29\":\"Content item 2\"}']" +
      "[data-module='track-click']"
    )
  end

  def and_i_can_see_tagged_content_to_the_taxon
    search_results.each do |search_result|
      assert page.has_link?(search_result['title'], search_result['link'])
      assert page.has_content?(search_result['description'])
    end
  end

  def and_the_content_tagged_to_the_grandfather_taxon_has_tracking_attributes
    assert_leaf_tracking_attributes_present('navGridLeafLinkClicked')
  end

  def and_the_content_tagged_to_the_leaf_taxon_has_tracking_attributes
    assert_leaf_tracking_attributes_present('navLeafLinkClicked')
  end

  def and_the_page_is_tracked_as_a_grid
    assert_navigation_page_type_tracking("grid")
  end

  def and_the_page_is_tracked_as_an_accordion
    assert_navigation_page_type_tracking("accordion")
  end

  def and_the_page_is_tracked_as_a_leaf_node_taxon
    assert_navigation_page_type_tracking("leaf")
  end

  def assert_navigation_page_type_tracking(expected_page_type)
    assert page.has_selector?("meta[name='govuk:navigation-page-type'][content='#{expected_page_type}']", visible: false)
  end

  def assert_leaf_tracking_attributes_present(tracking_category)
    tracked_links = page.all(:css, "a[data-track-category='#{tracking_category}']")
    tracked_links.size.must_equal search_results.size

    tracked_links.each_with_index do |link, index|
      expected_tracking_options = {
          dimension28: search_results.size.to_s,
          dimension29: search_results[index]['title'],
      }

      link[:'data-track-action'].must_equal "#{index + 1}"
      link[:'data-track-label'].must_equal search_results[index]['link']
      link[:'data-track-options'].must_equal expected_tracking_options.to_json
      link[:'data-module'].must_equal 'track-click'
    end

    # Test an example free from logic
    assert page.has_css?(
      "a[data-track-category='#{tracking_category}']" +
      "[data-track-action='2']" +
      "[data-track-label='content-item-2']" +
      "[data-track-options='{\"dimension28\":\"2\",\"dimension29\":\"Content item 2\"}']" +
      "[data-module='track-click']"
    )
  end
end
