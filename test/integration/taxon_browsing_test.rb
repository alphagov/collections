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
    assert_page_tracked_in_ab_test("NavigationTest", @blue_box_variant, '61')
    assert_response_is_cached_by_variant("NavigationTest")

    Capybara.reset_sessions!

    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = @existing_framework
    end
  end

  it 'is possible to browse a taxon page that has grandchildren' do
    given_i_am_in_the_a_variant_of_the_blue_box_ab_test
    given_there_is_a_taxon_with_grandchildren
    when_i_visit_the_taxon_page
    then_i_can_see_there_is_a_page_title
    then_i_can_see_the_meta_description
    then_i_can_see_the_breadcrumbs
    and_i_can_see_the_title_and_description
    and_i_can_see_links_to_the_child_taxons_in_a_grid
    and_the_grid_has_tracking_attributes
    and_i_can_see_content_tagged_to_the_taxon
    and_the_content_tagged_to_the_grandfather_taxon_has_tracking_attributes
    and_the_page_is_tracked_as_a_grid
    and_i_can_see_an_email_signup_link
  end

  it 'is possible to browse a taxon page that does not have grandchildren' do
    given_i_am_in_the_a_variant_of_the_blue_box_ab_test
    given_there_is_a_taxon_without_grandchildren
    when_i_visit_the_taxon_page
    then_i_can_see_there_is_a_page_title
    then_i_can_see_the_meta_description
    then_i_can_see_the_breadcrumbs
    and_i_can_see_the_title_and_description
    and_i_can_see_the_general_information_section_in_the_accordion
    and_i_can_see_links_to_the_child_taxons_in_an_accordion
    and_the_accordion_has_tracking_attributes
    and_i_can_see_content_tagged_to_the_taxon
    and_the_page_is_tracked_as_an_accordion
    and_i_can_see_an_email_signup_link
    and_all_sections_apart_from_general_information_have_an_email_signup_link
  end

  it 'does not show the general information section when there is no content tagged' do
    given_i_am_in_the_a_variant_of_the_blue_box_ab_test
    given_there_is_a_taxon_without_grandchildren
    and_the_taxon_has_no_tagged_content
    when_i_visit_the_taxon_page
    then_there_is_no_general_information_section_in_the_accordion
  end

  it 'is possible to browse a taxon page that does not have child taxons' do
    given_i_am_in_the_a_variant_of_the_blue_box_ab_test
    given_there_is_a_taxon_without_child_taxons
    when_i_visit_the_taxon_page
    then_i_can_see_there_is_a_page_title
    then_i_can_see_the_meta_description
    then_i_can_see_the_breadcrumbs
    and_i_can_see_the_title_and_description
    and_i_can_see_content_tagged_to_the_taxon
    and_the_content_tagged_to_the_leaf_taxon_has_tracking_attributes
    and_the_page_is_tracked_as_a_leaf_node_taxon
    and_i_can_see_an_email_signup_link
  end

  it 'includes content tagged to the associated_taxons' do
    given_i_am_in_the_a_variant_of_the_blue_box_ab_test
    given_there_is_a_taxon_with_associated_taxons
    when_i_visit_the_taxon_page
    then_i_can_see_there_is_a_page_title
    then_i_can_see_the_meta_description
    then_i_can_see_the_breadcrumbs
    and_i_can_see_the_title_and_description
    and_i_can_see_content_tagged_to_the_taxon_and_the_associate
  end

  it 'shows the blue box on an accordion page in the B variant' do
    given_i_am_in_the_b_variant_of_the_blue_box_ab_test
    given_there_is_a_taxon_without_grandchildren
    and_there_are_popular_items_for_the_taxon
    when_i_visit_the_taxon_page
    then_i_can_see_the_blue_box_with_its_details
    and_the_blue_box_links_have_tracking_attributes
  end

  it 'shows the blue box in a leaf page when there are more than 15 links in the B variant' do
    given_i_am_in_the_b_variant_of_the_blue_box_ab_test
    given_there_is_a_taxon_without_child_taxons
    and_there_are_popular_items_for_the_taxon
    when_i_visit_the_taxon_page
    then_i_can_see_the_blue_box_with_its_details
    and_the_blue_box_links_have_tracking_attributes
  end

  it 'does not appear in a leaf page when there are less that 15 links' do
    given_i_am_in_the_b_variant_of_the_blue_box_ab_test
    given_there_is_a_taxon_without_child_taxons
    and_that_taxon_has_few_content_items_tagged_to_it
    and_there_are_popular_items_for_the_taxon
    when_i_visit_the_taxon_page
    then_i_cannot_see_the_blue_box_section
  end

  it 'does not appear in the A variant of the Blue Box A/B test' do
    given_i_am_in_the_a_variant_of_the_blue_box_ab_test
    given_there_is_a_taxon_without_grandchildren
    and_there_are_popular_items_for_the_taxon
    when_i_visit_the_taxon_page
    then_i_cannot_see_the_blue_box_section
  end

private

  def given_i_am_in_the_b_variant_of_the_blue_box_ab_test
    setup_ab_variant("NavigationTest", "ShowBlueBox")
    @blue_box_variant = "ShowBlueBox"
  end

  def given_i_am_in_the_a_variant_of_the_blue_box_ab_test
    setup_ab_variant("NavigationTest", "NoBlueBox")
    @blue_box_variant = "NoBlueBox"
  end

  def then_i_can_see_the_blue_box_with_its_details
    blue_box = page.find('.high-volume')

    assert_equal(
      5,
      blue_box.all('a').count,
      'There should be 5 links in the blue box'
    )

    popular_items.each do |popular_item|
      assert blue_box.has_selector?('a', text: popular_item['title'])
    end
  end

  def then_i_cannot_see_the_blue_box_section
    refute page.has_selector?('.high-volume')
  end

  def search_results(count = 15)
    generate_search_results(count)
  end

  def popular_items
    generate_search_results(5)
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

  def and_there_are_popular_items_for_the_taxon
    raise "You need to setup a taxon before using this method" if @taxon.nil?

    stub_most_popular_content_for_taxon(
      @taxon.content_id,
      popular_items
    )
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

  def given_there_is_a_taxon_with_associated_taxons
    @base_path = '/world/usa/travelling-to-the-usa-taxon'
    taxon_with_associates = travelling_to_the_usa_taxon(base_path: @base_path)
    associates = taxon_with_associates['links']['associated_taxons']
    assert_not_nil associates

    associate_base_path = associates.first['base_path']
    associate_content_id = associates.first['content_id']

    content_store_has_item(@base_path, taxon_with_associates)
    content_store_has_item(associate_base_path, associates.first)
    @taxon = Taxon.find(@base_path)
    @associated_taxon = Taxon.find(associate_base_path)

    stub_content_for_taxon([@taxon.content_id, associate_content_id], search_results, filter_navigation_document_supertype: nil)
  end

  def and_that_taxon_has_few_content_items_tagged_to_it
    raise "You need to setup a taxon before using this method" if @taxon.nil?

    stub_content_for_taxon(@taxon.content_id, search_results(2))
  end

  def when_i_visit_the_taxon_page
    with_B_variant do
      visit @base_path

      if (400..599).cover?(page.status_code)
        raise "Application error (#{page.status_code}): \n#{page.body}"
      end
    end
  end

  def then_i_can_see_the_meta_description
    content = page.find('meta[name="description"]', visible: false)['content']

    assert_equal(
      @taxon.description,
      content,
      "The content of the meta description should be the taxon description"
    )
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
      assert page.has_link?(child_taxon['title'], href: child_taxon['base_path'])
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

  def and_i_can_see_the_general_information_section_in_the_accordion
    subsection = first('.subsection')

    assert subsection.has_selector?('.subsection-title', text: /general information and guidance/i)
    assert subsection.has_selector?(
      '.subsection-content .subsection-list-item a',
      count: search_results.count
    )
  end

  def then_there_is_no_general_information_section_in_the_accordion
    subsection = first('.subsection')

    assert_equal(
      false,
      subsection.has_selector?('.subsection-title', text: /general information and guidance/i)
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
      "[data-track-label='/content-item-2']" +
      "[data-track-options='{\"dimension28\":\"#{search_results.count}\",\"dimension29\":\"Content item 2\"}']" +
      "[data-module='track-click']"
    )
  end

  def and_i_can_see_content_tagged_to_the_taxon
    search_results.each do |search_result|
      assert page.has_link?(search_result['title'], href: /^.*#{search_result['link']}$/)
      assert page.has_content?(search_result['description'])
    end
  end

  alias_method :and_i_can_see_content_tagged_to_the_taxon_and_the_associate,
    :and_i_can_see_content_tagged_to_the_taxon

  def and_the_content_tagged_to_the_grandfather_taxon_has_tracking_attributes
    assert_leaf_tracking_attributes_present(
      'navGridLeafLinkClicked',
      search_results
    )
  end

  def and_the_blue_box_links_have_tracking_attributes
    assert_leaf_tracking_attributes_present(
      'navBlueBoxLinkClicked',
      popular_items
    )
  end

  def and_the_content_tagged_to_the_leaf_taxon_has_tracking_attributes
    assert_leaf_tracking_attributes_present(
      'navLeafLinkClicked',
      search_results
    )
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

  def and_i_can_see_an_email_signup_link
    govuk_title = page.find('.govuk-title')

    assert govuk_title.has_link?(
      'Get email alerts for this topic',
      href: "/email-signup/?topic=#{current_path}"
    )
  end

  def and_all_sections_apart_from_general_information_have_an_email_signup_link
    general_information, *subsections = page.all('.subsection').to_a

    refute general_information.has_link?(
      'Get email alerts for this topic'
    )

    subsections.each do |subsection|
      assert subsection.has_link?(
        'Get email alerts for this topic',
        href: "/email-signup/?topic=#{subsection[:id]}"
      )
    end
  end

  def assert_navigation_page_type_tracking(expected_page_type)
    assert page.has_selector?("meta[name='govuk:navigation-page-type'][content='#{expected_page_type}']", visible: false)
  end

  def assert_leaf_tracking_attributes_present(tracking_category, results)
    tracked_links = page.all(:css, "a[data-track-category='#{tracking_category}']")
    tracked_links.size.must_equal(results.size)

    tracked_links.each_with_index do |link, index|
      expected_tracking_options = {
          dimension28: results.size.to_s,
          dimension29: results[index]['title'],
      }

      link[:'data-track-action'].must_equal "#{index + 1}"
      link[:'data-track-label'].must_equal results[index]['link']
      link[:'data-track-options'].must_equal expected_tracking_options.to_json
      link[:'data-module'].must_equal 'track-click'
    end

    # Test an example free from logic
    assert page.has_css?(
      "a[data-track-category='#{tracking_category}']" +
      "[data-track-action='2']" +
      "[data-track-label='/content-item-2']" +
      "[data-track-options='{\"dimension28\":\"#{results.size}\",\"dimension29\":\"Content item 2\"}']" +
      "[data-module='track-click']"
    )
  end
end
