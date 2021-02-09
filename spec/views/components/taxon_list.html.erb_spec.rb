RSpec.describe "taxon-list component" do
  include ComponentTestHelper

  def component_name
    "taxon-list"
  end

  let(:item1) do
    {
      text: "Care to Learn",
      path: "/care-to-learn",
      description: "Care to Learn helps pay for childcare while you're studying",
    }
  end

  let(:item2) do
    {
      text: "Childcare Grant",
      path: "/childcare-grant",
      description: "Childcare Grants for full-time students in higher education",
    }
  end

  it "renders nothing without a list of items" do
    render_component({})
    expect(rendered).to be_empty
  end

  it "renders a list item with text, path and description" do
    render_component(items: [item1])

    expect(rendered).to have_link item1[:text], href: item1[:path], class: "app-c-taxon-list__link"
    expect(rendered).to have_selector(".app-c-taxon-list__description", text: item1[:description])
  end

  it "renders multiple list items" do
    render_component(items: [item1, item2])

    expect(rendered).to have_link item1[:text], href: item1[:path], class: "app-c-taxon-list__link"
    expect(rendered).to have_selector(".app-c-taxon-list__description", text: item1[:description])

    expect(rendered).to have_link item2[:text], href: item2[:path], class: "app-c-taxon-list__link"
    expect(rendered).to have_selector(".app-c-taxon-list__description", text: item2[:description])
  end

  it "renders a list item with no description" do
    render_component(items: [item2.without(:description)])

    # List item with no description should not be rendered inside a heading element
    expect(rendered).not_to have_link item2[:text], href: item2[:path], class: "app-c-taxon-list__heading app-c-taxon-list__link"
    expect(rendered).to have_link item2[:text], href: item2[:path], class: "app-c-taxon-list__link"
  end

  it "renders a list item with custom heading level" do
    render_component(items: [item2], heading_level: 3)

    selector = "h3.app-c-taxon-list__heading .app-c-taxon-list__link[href='#{item2[:path]}']"
    expect(rendered).to have_selector(selector, text: item2[:text])
  end

  it "renders a list item without a heading if heading_level is 0" do
    render_component(items: [item2], heading_level: 0)

    expect(rendered).not_to have_selector("h3.app-c-taxon-list__heading")

    expect(rendered).to have_link item2[:text], href: item2[:path], class: "app-c-taxon-list__link"
    expect(rendered).to have_selector(".app-c-taxon-list__item > .app-c-taxon-list__description", text: item2[:description])
  end

  it "defaults heading to h2 if heading level is out of range" do
    render_component(items: [item2], heading_level: 9)

    expect(rendered).to have_selector("h2.app-c-taxon-list__heading", text: item2[:text])
  end

  it "renders a list item with data attribute" do
    data_attributes = {
      "ecommerce-row": true,
      track_category: "trackCategory",
      track_action: 1.1,
      track_label: "/track-path",
      track_options: {
        dimension28: 2,
        dimension29: "Environmental taxes, reliefs and schemes for businesses",
      },
    }

    item2[:data_attributes] = data_attributes
    render_component(items: [item2], heading_level: 3)

    expect(rendered).to have_selector(".app-c-taxon-list__link[data-track-category=trackCategory]")
    expect(rendered).to have_selector(".app-c-taxon-list__link[data-ecommerce-row=true]")
  end
end
