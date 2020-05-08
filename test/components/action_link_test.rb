require "component_test_helper"

class ActionLinkTest < ComponentTestCase
  def component_name
    "action-link"
  end

  test "renders nothing without a href" do
    assert_empty render_component(text: "Get more info")
  end

  test "renders nothing without text" do
    assert_empty render_component(href: "/coronavirus")
  end

  test "renders non wrapping text if nowrap text is passed through" do
    render_component(
      text: "Get more info",
      nowrap_text: "about COVID",
      href: "/coronavirus",
    )
    assert_select ".app-c-action-link .app-c-action-link__nowrap-text", text: "about COVID"
  end

  test "renders simple icon version" do
    render_component(
      text: "Get more info",
      href: "/coronavirus",
      simple: true,
    )
    assert_select ".app-c-action-link--simple"
  end

  test "renders dark icon version" do
    render_component(
      text: "Get more info",
      href: "/coronavirus",
      dark_icon: true,
    )
    assert_select ".app-c-action-link--dark-icon"
  end

  test "renders light text version" do
    render_component(
      text: "Get more info",
      href: "/coronavirus",
      light_text: true,
    )
    assert_select ".app-c-action-link--light-text"
  end

  test "renders compact version" do
    render_component(
      text: "Get more info",
      href: "/coronavirus",
      compact: true,
    )
    assert_select ".app-c-action-link--compact"
  end

  test "has data attributes if data attributes are passed in" do
    render_component(
      text: "Get more info",
      href: "/coronavirus",
      data: {
        testing: "hasDataAttribute",
      },
    )
    assert_select ".app-c-action-link__link[data-testing='hasDataAttribute']"
  end
end
