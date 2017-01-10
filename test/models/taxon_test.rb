require 'test_helper'

describe Taxon do
  setup do
    api_data = {
      'content_id' => 'student-finance-content-id',
      'title' => 'Student finance',
      'description' => 'Student finance content',
      'base_path' => '/student-finance',
      'links' => {
        'parent_taxon' => [
          'title' => 'Education and learning',
          'description' => 'Education and learning description',
          'base_path' => '/alpha-taxonomy/education'
        ],
        'child_taxons' => [
          {
            'title' => 'Student sponsorship',
            'description' => 'Description of student sponsorship',
            'base_path' => '/alpha-taxonomy/student-sponsorship'
          },
          {
            'title' => 'Student loans',
            'description' => 'Description of student loans',
            'base_path' => '/alpha-taxonomy/student-loans'
          }
        ]
      }
    }
    content_item = ContentItem.new(api_data)
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
