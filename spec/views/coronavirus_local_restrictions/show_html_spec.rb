require "test_helper"
module CoronavirusLocalRestrictions
  class ShowHtmlTest < ActionView::TestCase
    include CoronavirusLocalRestrictionsHelpers
    helper Rails.application.helpers

    describe "errors" do
      test "rendering error when invalid postcode is entered" do
        postcode = "hello"

        render_show_view(postcode)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.input_error")
      end

      test "rendering error when postcode does not exist" do
        postcode = "XM4 5HQ"

        stub_mapit_does_not_have_a_postcode(postcode)

        render_show_view(postcode)

        assert_includes rendered, I18n.t("coronavirus_local_restrictions.errors.postcode_not_found.input_error")
      end
    end

    def render_show_view(postcode)
      @search = PostcodeLocalRestrictionSearch.new(postcode)
      @content_item = coronavirus_content_item

      view.stubs(:out_of_date?).returns(false)

      render template: "coronavirus_local_restrictions/show"
    end
  end
end
