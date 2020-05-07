require "component_test_helper"

class TopicListTest < ComponentTestCase
  def component_name
    "topic-list"
  end

  def simple_item
    [
      {
        path: "/path",
        text: "Text",
      },
    ]
  end

  def see_more_link
    {
      path: "/more",
      text: "More",
      data_attributes: { test: "test" },
    }
  end

  test "renders nothing without a list of items" do
    assert_empty render_component({})
  end

  test "renders a list of links" do
    render_component(items: [{ path: "/path", text: "Text" }])
    assert_select ".app-c-topic-list__link[href='/path']", text: "Text"
  end

  test "renders links with data attributes" do
    render_component(items: [
      {
        path: "/path",
        text: "Text",
        data_attributes: {
          test: "test",
        },
      },
    ])

    assert_select ".app-c-topic-list__link[data-test='test']"
  end

  test "renders a see more link" do
    render_component(items: simple_item, see_more_link: see_more_link)
    assert_select ".app-c-topic-list__item a[href='/more'][data-test='test']", text: "More"
  end

  test "adds branding correctly" do
    render_component(items: simple_item, see_more_link: see_more_link, brand: "attorney-generals-office")
    assert_select ".app-c-topic-list.brand--attorney-generals-office"
    assert_select ".app-c-topic-list .app-c-topic-list__link.brand__color"
    assert_select ".brand__color", text: "More"
  end

  test "renders small version" do
    render_component(items: simple_item, small: true)
    assert_select ".app-c-topic-list.app-c-topic-list--small"
  end

  test "renders with margin-bottom" do
    render_component(items: simple_item)
    assert_select ".app-c-topic-list--margin-bottom", false, "Margin bottom should not be applied by default"

    render_component(items: simple_item, margin_bottom: true)
    assert_select ".app-c-topic-list--margin-bottom"
  end
end
