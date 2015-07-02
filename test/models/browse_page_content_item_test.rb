require "test_helper"

describe BrowsePageContentItem do

  describe '#lists' do
    it "constructs a ListSet with the tag type and slug" do
      ListSet.expects(:new).with("section", "crime-and-justice/judges", anything()).returns(:a_lists_instance)

      page = BrowsePageContentItem.new('crime-and-justice/judges', stub(:details))
      assert_equal :a_lists_instance, page.lists
    end

    it "passes the groups data when constructing" do
      ListSet.expects(:new).with(anything(), anything(), :some_data).returns(:a_lists_instance)

      stub_content_item = stub(:details => stub(:groups => :some_data))

      page = BrowsePageContentItem.new('crime-and-justice/judges', stub_content_item)
      assert_equal :a_lists_instance, page.lists
    end
  end
end
