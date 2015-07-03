require 'test_helper'

describe SecondLevelBrowsePage do
  describe 'delegated accessor methods' do
    it 'delegates title to the browse page' do
      content_store_has_item('/browse/foo/bar', { title: 'Foo Bar' })

      page = SecondLevelBrowsePage.new('foo', 'bar')

      assert_equal 'Foo Bar', page.title
    end

    it 'delegates description to the browse page' do
      content_store_has_item('/browse/foo/bar', { description: 'Descriptive text' })

      page = SecondLevelBrowsePage.new('foo', 'bar')

      assert_equal 'Descriptive text', page.description
    end
  end

  describe '#lists' do
    setup do
      @stub_content_item = stub(:details => stub(:groups => :some_data))
      ContentItem.stubs(:find!).returns(@stub_content_item)
    end

    it "constructs a ListSet with the tag type and slug" do
      ListSet.expects(:new).with("section", "crime-and-justice/judges", anything()).returns(:a_lists_instance)

      page = SecondLevelBrowsePage.new('crime-and-justice', 'judges')
      assert_equal :a_lists_instance, page.lists
    end

    it "passes the groups data when constructing" do
      ListSet.expects(:new).with(anything(), anything(), :some_data).returns(:a_lists_instance)

      page = SecondLevelBrowsePage.new('crime-and-justice', 'judges')
      assert_equal :a_lists_instance, page.lists
    end
  end
end
