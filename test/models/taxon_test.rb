require 'test_helper'

describe Taxon do
  include TaxonHelpers

  setup do
    content_item = ContentItem.new(student_finance_taxon)
    @taxon = Taxon.new(content_item)
  end

  it 'has a title' do
    assert_equal @taxon.title, student_finance_taxon['title']
  end

  it 'has a description' do
    assert_equal @taxon.description, student_finance_taxon['description']
  end

  it 'has a content id' do
    assert_equal @taxon.content_id, student_finance_taxon['content_id']
  end

  it 'has a base path' do
    assert_equal @taxon.base_path, student_finance_taxon['base_path']
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
