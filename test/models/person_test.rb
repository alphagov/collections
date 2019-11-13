require "test_helper"

describe Person do
  setup do
    @api_data = {
      "links" => {
        "ordered_current_appointments" => [
          {
            "links" => {
              "role" => [{
                "title" => "Prime Minister",
              }],
            },
          },
          {
            "links" => {
              "role" => [{
                "title" => "First Lord of the Treasury",
              }],
            },
          },
        ],
      },
    }
    @content_item = ContentItem.new(@api_data)
    @person = Person.new(@content_item)
  end

  describe "current_roles_title" do
    it "combines the titles into a sentence" do
      assert_equal "Prime Minister and First Lord of the Treasury", @person.current_roles_title
    end
  end
end
