require 'integration_test_helper'
require 'slimmer/test_helpers/govuk_components'

class TaxonBrowsingTest < ActionDispatch::IntegrationTest
  include RummagerHelpers
  include TaxonHelpers
  include Slimmer::TestHelpers::GovukComponents

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

  it 'is possible to browse a taxon page that has grandchildren' do
    given_there_is_a_taxon_with_grandchildren
    when_i_visit_the_taxon_page
    then_i_can_see_the_breadcrumbs
    and_i_can_see_a_link_to_the_parent_taxon
    and_i_can_see_the_title_and_description
    and_i_can_see_links_to_the_child_taxons_in_a_grid
    and_i_can_see_tagged_content_to_the_taxon
  end

  it 'is possible to browse a taxon page that does not have grandchildren' do
    given_there_is_a_taxon_without_grandchildren
    when_i_visit_the_taxon_page
    then_i_can_see_the_breadcrumbs
    and_i_can_see_a_link_to_the_parent_taxon
    and_i_can_see_the_title_and_description
    and_i_can_see_links_to_the_child_taxons_in_an_accordion
    and_i_can_see_tagged_content_to_the_taxon
  end

  def given_there_is_a_taxon_with_grandchildren
    @base_path = '/alpha-taxonomy/funding_and_finance_for_students'
    funding_and_finance_for_students = funding_and_finance_for_students(base_path: @base_path)

    @parent = funding_and_finance_for_students['links']['parent_taxons'].first
    @child_taxons = funding_and_finance_for_students['links']['child_taxons']

    content_store_has_item(@base_path, funding_and_finance_for_students)
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
    @base_path = '/alpha-taxonomy/student-finance'
    student_finance = student_finance_taxon(base_path: @base_path)

    @parent = student_finance['links']['parent_taxons'].first
    @child_taxons = student_finance['links']['child_taxons']

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

  def when_i_visit_the_taxon_page
    visit @base_path
  end

  def then_i_can_see_the_breadcrumbs
    assert_not_nil shared_component_selector('breadcrumbs')
  end

  def and_i_can_see_a_link_to_the_parent_taxon
    assert page.has_link?(@parent['title'], @parent['description'])
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

  def and_i_can_see_links_to_the_child_taxons_in_an_accordion
    assert page.has_selector?('.child-topic-contents')

    @child_taxons.each do |child_taxon|
      assert page.has_content?(child_taxon['title'])
      assert page.has_content?(child_taxon['description'])
    end
  end

  def and_i_can_see_tagged_content_to_the_taxon
    search_results.each do |search_result|
      assert page.has_link?(search_result['title'], search_result['link'])
      assert page.has_content?(search_result['description'])
    end
  end
end
