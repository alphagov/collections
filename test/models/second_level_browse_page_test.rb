require 'test_helper'

describe SecondLevelBrowsePage do
  describe '#title' do
    it 'delegates to the browse page' do
      content_store_has_item('/browse/foo/bar', { title: 'Foo Bar' })

      page = SecondLevelBrowsePage.new('foo', 'bar')

      assert_equal page.title, 'Foo Bar'
    end
  end
end
