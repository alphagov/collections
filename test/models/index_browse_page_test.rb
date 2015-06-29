require 'test_helper'

describe IndexBrowsePage do
  describe '#top_level_browse_pages' do
    it 'returns the top level browse pages' do
      content_store_has_item('/browse', { links: {
        top_level_browse_pages: [{ title: 'Crime and justice', base_path: '/browse/crime-and-justice' }]
        }
      })

      page = IndexBrowsePage.new
      top_level_page = page.top_level_browse_pages.first

      assert_equal 'Crime and justice', top_level_page.title
      assert_equal '/browse/crime-and-justice', top_level_page.base_path
    end
  end
end
