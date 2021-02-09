require "component_test_helper"

class HeaderNoticeTest < ComponentTestCase
  def component_name
    "header-notice"
  end

  def branded_notice
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

  def unbranded_notice
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

  def list_with_links
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

  test "renders nothing without passed content" do
    assert_empty render_component({})
  end

  test "renders a notice correctly if no branding is passed in" do
    render_component(unbranded_notice)
    assert_select ".app-c-header-notice"
  end

  test "renders a branded notice if branding is passed in" do
    render_component(branded_notice)
    assert_select ".app-c-header-notice.app-c-header-notice__branding--nhs"
  end

  test "renders a logo if title logo is passed in" do
    render_component(branded_notice)
    assert_select ".app-c-header-notice__title-logo", attributes: { src: branded_notice[:title_logo_url] }
    assert_select ".app-c-header-notice__title", count: 0
  end

  test "renders a title if title is passed in" do
    render_component(unbranded_notice)
    assert_select ".app-c-header-notice__title", text: branded_notice[:title]
    assert_select ".app-c-header-notice__title-logo", count: 0
  end

  test "renders a title and logo if title and logo are both passed in" do
    config = branded_notice
    config[:title] = "this is a title"
    render_component(config)
    assert_select ".app-c-header-notice__title", text: config[:title]
    assert_select ".app-c-header-notice__title-logo", attributes: { src: config[:title_logo_url] }
  end

  test "does not renders a heading if no heading is passed in" do
    render_component(branded_notice.without(:heading))
    assert_select ".gem-c-heading", count: 0
  end

  test "renders a heading if heading is passed in" do
    render_component(branded_notice)
    assert_select ".gem-c-heading", text: branded_notice[:heading]
  end

  test "does not renders a list if no list is passed in" do
    render_component(branded_notice.without(:list))
    assert_select ".app-c-header-notice__list", count: 0
  end

  test "renders a list if list is passed in" do
    render_component(branded_notice)
    assert_select ".app-c-header-notice__list"
    assert_select ".app-c-header-notice__list li", count: branded_notice[:list].count
    assert_select ".app-c-header-notice__list li" do |items|
      items.each_with_index do |item, index|
        assert_equal item.text.strip, branded_notice[:list][index]
      end
    end
  end

  test "renders a list with links if list with links is passed in" do
    render_component(list_with_links)
    assert_select ".app-c-header-notice__list"
    assert_select ".app-c-header-notice__list li", count: list_with_links[:list].count
    assert_select ".app-c-header-notice__list li a", count: 1
    assert_select ".app-c-header-notice__list li" do |items|
      items.each_with_index do |item, index|
        if list_with_links[:list][index].is_a?(Hash)
          assert_select "a[href=?]", list_with_links[:list][index]["href"],
                        {
                          count: 1,
                          text: list_with_links[:list][index]["label"],
                        }
        else
          assert_equal item.text.strip, list_with_links[:list][index]
        end
      end
    end
  end

  test "does not renders a call to action if no call to action is passed in" do
    render_component(branded_notice.without(:call_to_action))
    assert_select ".app-c-header-notice__call-to-action", count: 0
  end

  test "renders a call to action if a call to action is passed in" do
    render_component(branded_notice)
    assert_select ".app-c-header-notice__call-to-action-link",
                  {
                    text: branded_notice[:call_to_action][:title],
                    href: branded_notice[:call_to_action][:href],
                  }
  end
end
