require 'integration_test_helper'

class TaxonBrowsingTest < ActionDispatch::IntegrationTest
  include RummagerHelpers
  include TaxonHelpers

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

  before do
    @base_path = '/alpha-taxonomy/student-finance'
    content_store_has_item(@base_path, education_content_item(base_path: @base_path))
    @taxon = Taxon.find(@base_path)
    stub_content_for_taxon(@taxon.content_id, search_results)
  end

  it 'is possible to visit a taxon show page' do
    get @base_path
    assert_equal 200, status
  end

  it 'is possible to see breadcrumbs' do
    visit @base_path

    assert page.has_content?('Home')
  end

  it 'is possible to see a link to the parent taxon' do
    visit @base_path

    assert page.has_link?('Education and learning', "/alpha-taxonomy/education")
  end

  it 'is possible to see the taxon title and description' do
    visit @base_path

    assert page.has_content?(@taxon.title)
    assert page.has_content?(@taxon.description)
  end

  it 'is possible to see links to the child taxons' do
    visit @base_path

    assert page.has_link?("Student sponsorship", "/alpha-taxonomy/student-sponsorship")
    assert page.has_content?("Description of student sponsorship")
    assert page.has_link?("Student loans", "/alpha-taxonomy/student-loans")
    assert page.has_content?("Description of student loans")
  end


  it 'is possible to see content tagged to the taxon' do
    visit @base_path

    assert page.has_link?("Content item 1", "/content-item-1")
    assert page.has_content?("Description of content item 1")
    assert page.has_link?("Content item 2", "/content-item-2")
    assert page.has_content?("Description of content item 2")
  end
end
