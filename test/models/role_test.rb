require "test_helper"

describe Role do
  setup do
    @api_data = {
      "base_path" => "/government/ministers/prime-minister",
      "links" => {
        "ordered_parent_organisations" => [
          {
            "base_path" => "/government/organisations/cabinet-office",
            "title" => "Cabinet Office",
          },
          {
            "base_path" => "/government/organisations/prime-ministers-office-10-downing-street",
            "title" => "Prime Minister's Office, 10 Downing Street",
          },
        ],
      },
    }
    @content_item = ContentItem.new(@api_data)
    @role = Role.new(@content_item)
  end

  describe "organisations" do
    it "should have organisations title and base_path" do
      expected = [
        {
          "title" => "Cabinet Office",
          "base_path" => "/government/organisations/cabinet-office",
        },
        {
          "title" => "Prime Minister's Office, 10 Downing Street",
          "base_path" => "/government/organisations/prime-ministers-office-10-downing-street",
        },
      ]
      assert_equal expected, @role.organisations
    end
  end
end
