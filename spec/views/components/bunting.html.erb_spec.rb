RSpec.describe "bunting component" do
  include ComponentTestHelper

  def component_name
    "bunting"
  end

  it "renders the bunting component" do
    render_component({})
    expect(rendered).to have_selector(".app-c-bunting")
  end

  it "renders the bunting component with a spacer to offset the height taken up" do
    render_component({})
    expect(rendered).to have_selector(".app-c-bunting--spacer")
  end

  it "renders the bunting component with a spacer to offset the height taken up" do
    render_component({})
    expect(rendered).to have_selector(".app-c-bunting--spacer")
  end

  it "renders with the relevant aria attributes " do
    render_component({})
    assert_select ".app-c-bunting[aria-hidden='true']", count: 1
    assert_select ".app-c-bunting--spacer[aria-hidden='true']", count: 1
  end
end
