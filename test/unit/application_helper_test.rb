require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  tests ApplicationHelper

  describe "#current_path_without_query_string" do
    it "returns the path of the current request" do
      self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => '/foo/bar'))
      assert_equal '/foo/bar', current_path_without_query_string
    end

    it "returns the path of the current request stripping off any query string parameters" do
      self.stubs(:request).returns(ActionDispatch::TestRequest.create("PATH_INFO" => '/foo/bar', "QUERY_STRING" => 'ham=jam&spam=gram'))
      assert_equal '/foo/bar', current_path_without_query_string
    end
  end
end
