RSpec.describe "coronavirus_local_restrictions/show.html.erb" do
  include CoronavirusLocalRestrictionsHelpers

  describe "errors" do
    it "rendering error when invalid postcode is entered" do
      postcode = "hello"

      render_show_view(postcode)

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.errors.invalid_postcode.input_error"))
    end

    it "rendering error when postcode does not exist" do
      postcode = "XM4 5HQ"

      stub_mapit_does_not_have_a_postcode(postcode)

      render_show_view(postcode)

      expect(rendered).to match(I18n.t("coronavirus_local_restrictions.errors.postcode_not_found.input_error"))
    end
  end

  def render_show_view(postcode)
    @search = PostcodeLocalRestrictionSearch.new(postcode)
    @content_item = coronavirus_content_item
    allow(view)
    .to receive(:out_of_date?)
    .and_return(false)
    render
  end
end
