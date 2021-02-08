RSpec.describe "header-notice component" do
  include ComponentTestHelper

  def component_name
    "header-notice"
  end

  let(:branded_notice) do
    {
      nhs_branding: true,
      title_logo: tag.img(src: "/path/to/image.png"),
      heading: "This is a header",
      list: %w[blah blah2],
      call_to_action: {
        href: "/this-is-a-link",
        title: "Click me!",
      },
    }
  end

  let(:unbranded_notice) do
    {
      title: "this is a title",
      heading: "This is a header",
      list: %w[blah blah2],
      call_to_action: {
        href: "/this-is-a-link",
        title: "Click me!",
      },
    }
  end

  let(:list_with_links) do
    {
      title: "this is a title",
      heading: "This is a header",
      list: ["blah", "blah2", { "label" => "blahWithLink", "href" => "/blah" }],
      call_to_action: {
        href: "/this-is-a-link",
        title: "Click me!",
      },
    }
  end

  it "renders nothing without passed content" do
    render_component({})
    expect(rendered).to be_empty
  end

  it "renders a notice correctly if no branding is passed in" do
    render_component(unbranded_notice)
    expect(rendered).to have_selector(".app-c-header-notice")
  end

  it "renders a branded notice if branding is passed in" do
    render_component(branded_notice)
    expect(rendered).to have_selector(".app-c-header-notice.app-c-header-notice__branding--nhs")
  end

  it "renders a logo if title logo is passed in" do
    render_component(branded_notice)
    within ".app-c-header-notice__title-logo" do
      expect(rendered).to have_selector("img[src='/path/to/image.png']", count: 1)
    end
    expect(rendered).not_to have_selector(".app-c-header-notice__title")
  end

  it "renders a title if title is passed in" do
    render_component(unbranded_notice)
    expect(rendered).to have_selector(".app-c-header-notice__title", text: branded_notice[:title])
    expect(rendered).to have_selector(".app-c-header-notice__title-logo", count: 0)
  end

  it "renders a title and logo if title and logo are both passed in" do
    notice = branded_notice
    notice[:title] = "this is a title"

    render_component(notice)
    within ".app-c-header-notice__title-logo" do
      expect(rendered).to have_selector("img[src='/path/to/image.png']", count: 1)
    end
    expect(rendered).to have_selector(".app-c-header-notice__title", text: notice[:title])
  end

  it "does not renders a heading if no heading is passed in" do
    render_component(branded_notice.without(:heading))
    expect(rendered).to have_selector(".gem-c-heading", count: 0)
  end

  it "renders a heading if heading is passed in" do
    render_component(branded_notice)
    expect(rendered).to have_selector(".gem-c-heading", text: branded_notice[:heading])
  end

  it "does not renders a list if no list is passed in" do
    render_component(branded_notice.without(:list))
    expect(rendered).to have_selector(".app-c-header-notice__list", count: 0)
  end

  it "renders a list if list is passed in" do
    render_component(branded_notice)
    expect(rendered).to have_selector(".app-c-header-notice__list")
    expect(rendered).to have_selector(".app-c-header-notice__list li", count: branded_notice[:list].count)
    expect(rendered).to have_selector(".app-c-header-notice__list li") do |items|
      items.each_with_index do |item, index|
        expect(branded_notice[:list][index]).to eq(item.text.strip)
      end
    end
  end

  it "renders a list with links if list with links is passed in" do
    list_count = list_with_links[:list].count

    render_component(list_with_links)
    expect(rendered).to have_selector(".app-c-header-notice__list")
    expect(rendered).to have_selector(".app-c-header-notice__list li", count: list_count)
    expect(rendered).to have_selector(".app-c-header-notice__list li a", count: 1)
    expect(rendered).to have_selector(".app-c-header-notice__list li") do |items|
      items.each_with_index do |item, index|
        if list_with_links[:list][index].is_a?(Hash)
          expect(rendered).to have_link(
            list_with_links[:list][index]["href"],
            count: 1,
            text: list_with_links[:list][index]["label"],
          )
        else
          expect(list_with_links[:list][index]).to eq(item.text.strip)
        end
      end
    end
  end

  it "does not renders a call to action if no call to action is passed in" do
    render_component(branded_notice.without(:call_to_action))
    expect(rendered).to have_selector(".app-c-header-notice__call-to-action", count: 0)
  end

  it "renders a call to action if a call to action is passed in" do
    css_class = "app-c-header-notice__call-to-action-link"
    title = branded_notice[:call_to_action][:title]
    href = branded_notice[:call_to_action][:href]

    render_component(branded_notice)
    expect(rendered).to have_link title, href: href, class: css_class
  end
end
