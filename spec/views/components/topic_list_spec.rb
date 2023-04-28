RSpec.describe "topic_list component" do
  include ComponentTestHelper

  def component_name
    "topic_list"
  end

  let(:simple_item) do
    {
      path: "/path",
      text: "Text",
    }
  end

  let(:see_more_link) do
    {
      path: "/more",
      text: "More",
      data_attributes: { test: "test" },
    }
  end

  it "renders nothing without a list of items" do
    render_component({})
    expect(rendered).to be_empty
  end

  it "renders a list of links" do
    render_component(items: [simple_item])
    expect(rendered).to have_selector(%(.app-c-topic-list__link[href="#{simple_item[:path]}"]), text: simple_item[:text])
  end

  it "renders links with data attributes" do
    simple_item[:data_attributes] = { test: "test" }
    render_component(items: [simple_item])

    expect(rendered).to have_selector(".app-c-topic-list__link[data-test='test']")
  end

  it "renders a see more link" do
    render_component(items: [simple_item], see_more_link:)
    expect(rendered).to have_selector(".app-c-topic-list__item a[href='/more'][data-test='test']", text: "More")
  end

  it "adds branding correctly" do
    render_component(items: [simple_item], see_more_link:, brand: "attorney-generals-office")
    expect(rendered).to have_selector(".app-c-topic-list.brand--attorney-generals-office")
    expect(rendered).to have_selector(".app-c-topic-list .app-c-topic-list__link.brand__color")
    expect(rendered).to have_selector(".brand__color", text: "More")
  end

  it "renders small version" do
    render_component(items: [simple_item], small: true)
    expect(rendered).to have_selector(".app-c-topic-list.app-c-topic-list--small")
  end

  it "renders with margin-bottom" do
    render_component(items: [simple_item])
    # Margin bottom should not be applied by default
    expect(rendered).not_to have_selector(".govuk-\\!-margin-bottom-6")

    render_component(items: [simple_item], margin_bottom: true)
    expect(rendered).to have_selector(".govuk-\\!-margin-bottom-6")
  end
end
