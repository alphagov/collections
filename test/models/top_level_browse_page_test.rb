require 'test_helper'

describe TopLevelBrowsePage do
  describe '#title' do
    it 'delegates to the browse page' do
      content_store_has_item('/browse/foo', { title: 'Foo Bar' })

      page = TopLevelBrowsePage.new('foo')

      assert_equal page.title, 'Foo Bar'
    end
  end
end
