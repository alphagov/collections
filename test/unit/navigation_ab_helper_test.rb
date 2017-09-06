require 'test_helper'

class NavigationAbHelperTest < ActionView::TestCase
  tests NavigationAbHelper

  describe "#legacy_navigation_meta_tag" do
    it "returns a 'govuk:navigation-legacy' meta tag if given an identifier" do
      expected = "<meta name='govuk:navigation-legacy' content='foo'>"
      result = legacy_navigation_meta_tag('foo')
      assert_equal expected, result
    end

    it "returns empty string if called with nil" do
      assert_equal '', legacy_navigation_meta_tag(nil)
    end
  end
end
