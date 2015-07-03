require 'test_helper'

describe TopLevelBrowsePage do
  describe 'delegated accessor methods' do
    it 'delegates title to the browse page' do
      content_store_has_item('/browse/foo', { title: 'Foo Bar' })

      page = TopLevelBrowsePage.new('foo')

      assert_equal 'Foo Bar', page.title
    end

    it 'delegates description to the browse page' do
      content_store_has_item('/browse/foo', { description: 'Descriptive text' })

      page = TopLevelBrowsePage.new('foo')

      assert_equal 'Descriptive text', page.description
    end
  end
end
