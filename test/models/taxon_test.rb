require 'test_helper'

describe Taxon do
  include TaxonHelpers

  setup do
    content_item = ContentItem.new(education_content_item)
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
    assert_equal @taxon.base_path, '/student-finance'
  end

  it 'has parent taxon' do
    parent = @taxon.parent_taxon

    assert_instance_of Taxon, parent
    assert_equal parent.title, 'Education and learning'
    assert_equal parent.description, 'Education and learning description'
    assert_equal parent.base_path, '/alpha-taxonomy/education'
  end

  it 'has two taxon children' do
    assert_equal @taxon.child_taxons.length, 2

    @taxon.child_taxons.each do |child|
      assert_instance_of Taxon, child
      assert_includes ['Student sponsorship', 'Student loans'], child.title
    end
  end
end
