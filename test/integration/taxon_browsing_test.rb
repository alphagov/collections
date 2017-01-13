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

  describe 'Browsing taxon with grandchildren' do
    before do
      @base_path = '/alpha-taxonomy/funding_and_finance_for_students'
      funding_and_finance_for_students = funding_and_finance_for_students(base_path: @base_path)

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

      assert page.has_link?(
        'Education and learning',
        '/alpha-taxonomy/education'
      )
    end

    it 'is possible to see the taxon title and description' do
      visit @base_path

      assert page.has_content?(@taxon.title)
      assert page.has_content?(@taxon.description)
    end

    it 'is possible to see links to the child taxons in a grid' do
      visit @base_path

      assert page.has_selector?('nav.child-topics-list')
      assert page.has_link?("Student finance", "/alpha-taxonomy/student-finance")
      assert page.has_content?("Student finance content")
    end

    it 'is possible to see content tagged to the taxon' do
      visit @base_path

      assert page.has_link?("Content item 1", "/content-item-1")
      assert page.has_content?("Description of content item 1")
      assert page.has_link?("Content item 2", "/content-item-2")
      assert page.has_content?("Description of content item 2")
    end
  end

  describe 'Browsing taxon without grandchildren' do
    before do
      @base_path = '/alpha-taxonomy/student-finance'
      student_finance = student_finance_taxon(base_path: @base_path)

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

      assert page.has_link?(
        'Funding and finance for students',
        '/alpha-taxonomy/funding-and-finance-for-students'
      )
    end

    it 'is possible to see the taxon title and description' do
      visit @base_path

      assert page.has_content?(@taxon.title)
      assert page.has_content?(@taxon.description)
    end

    it 'is possible to see links to the child taxons in a accordion' do
      visit @base_path

      assert page.has_selector?('.child-topic-contents')
      assert page.has_content?("Student sponsorship")
      assert page.has_content?("Description of student sponsorship")
      assert page.has_content?("Student loans")
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
end
