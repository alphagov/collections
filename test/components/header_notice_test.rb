require "component_test_helper"

class HeaderNoticeTest < ComponentTestCase
  def component_name
    "header-notice"
  end

  def branded_noticed
    {
      branding_classes: "app-c-header-notice__branding--nhs",
      title_logo_url: "/path/to/image.png",
      heading: "This is a header",
      list: %w(blah blah2),
      call_to_action: {
        href: "/this-is-a-link",
        title: "Click me!",
      },
    }
  end

  def unbranded_noticed
    {
      title: "this is a title",
      heading: "This is a header",
      list: %w(blah blah2),
      call_to_action: {
        href: "/this-is-a-link",
        title: "Click me!",
      },
    }
  end

  test "renders nothing without passed content" do
    assert_empty render_component({})
  end

  test "renders a notice correctly if no branding is passed in" do
    render_component(unbranded_noticed)
    assert_select ".app-c-header-notice"
  end

  test "renders a branded notice if branding is passed in" do
    render_component(branded_noticed)
    assert_select ".app-c-header-notice.#{branded_noticed[:branding_classes]}"
  end

  test "renders a logo if title logo is passed in" do
    render_component(branded_noticed)
    assert_select "img.app-c-header-notice__title-logo", attributes: { src: branded_noticed[:title_logo_url] }
    assert_select ".app-c-header-notice__title", count: 0
  end

  test "renders a title if title is passed in" do
    render_component(unbranded_noticed)
    assert_select ".app-c-header-notice__title", text: branded_noticed[:title]
    assert_select "img.app-c-header-notice__title-logo", count: 0
  end

  test "renders a title and logo if title and logo are both passed in" do
    config = branded_noticed
    config[:title] = "this is a title"
    render_component(config)
    assert_select ".app-c-header-notice__title", text: config[:title]
    assert_select "img.app-c-header-notice__title-logo", attributes: { src: config[:title_logo_url] }
  end

  test "does not renders a heading if no heading is passed in" do
    render_component(branded_noticed.without(:heading))
    assert_select ".app-c-header-notice__heading", count: 0
  end

  test "renders a heading if heading is passed in" do
    render_component(branded_noticed)
    assert_select ".app-c-header-notice__heading", text: branded_noticed[:heading]
  end

  test "does not renders a list if no list is passed in" do
    render_component(branded_noticed.without(:list))
    assert_select ".app-c-header-notice__list", count: 0
  end

  test "renders a list if list is passed in" do
    render_component(branded_noticed)
    assert_select ".app-c-header-notice__list"
    assert_select ".app-c-header-notice__list li", count: branded_noticed[:list].count
    assert_select ".app-c-header-notice__list li" do |items|
      items.each_with_index do |item, index|
        assert_equal item.text, branded_noticed[:list][index]
      end
    end
  end

  test "does not renders a call to action if no call to action is passed in" do
    render_component(branded_noticed.without(:call_to_action))
    assert_select ".app-c-header-notice__call-to-action", count: 0
  end

  test "renders a call to action if a call to action is passed in" do
    render_component(branded_noticed)
    assert_select ".app-c-header-notice__call-to-action-link", {
      text: branded_noticed[:call_to_action][:title],
      href: branded_noticed[:call_to_action][:href],
    }
  end
end
