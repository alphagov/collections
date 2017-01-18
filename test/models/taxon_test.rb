require 'test_helper'

describe Taxon do
  include TaxonHelpers

  setup do
    content_item = ContentItem.new(student_finance_taxon)
    @taxon = Taxon.new(content_item)
  end

  it 'has a title' do
    assert_equal @taxon.title, 'Student finance'
  end

  it 'has a description' do
    assert_equal @taxon.description, 'Student finance content'
  end

  it 'has a content id' do
    assert_equal @taxon.content_id, 'student-finance-content-id'
  end

  it 'has a base path' do
    assert_equal @taxon.base_path, '/alpha-taxonomy/student-finance'
  end

  it 'has parent taxon' do
    parent = @taxon.parent_taxon

    assert_instance_of Taxon, parent
    assert_equal parent.title, 'Funding and finance for students'
    assert_equal parent.description, 'Description for funding and finance for students'
    assert_equal parent.base_path, '/alpha-taxonomy/funding-and-finance-for-students'
  end

  it 'has two taxon children' do
    assert_equal @taxon.child_taxons.length, 2

    @taxon.child_taxons.each do |child|
      assert_instance_of Taxon, child
      assert_includes ['Student sponsorship', 'Student loans'], child.title
    end
  end

  it 'has grandchildren' do
    taxon = stub(children?: true)
    Taxon.stubs(:find).returns(taxon)

    assert @taxon.has_grandchildren?
  end

  it 'does not have grandchildren' do
    taxon = stub(children?: false)
    Taxon.stubs(:find).returns(taxon)

    assert not(@taxon.has_grandchildren?)
  end
end
