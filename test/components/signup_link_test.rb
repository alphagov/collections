require "component_test_helper"

class EmailNotificationsSectionTest < ComponentTestCase
  def component_name
    "signup-link"
  end

  test "renders nothing with no input" do
    assert_empty render_component({})
  end

  test "renders link when link is passed" do
    render_component(
      heading: "Stay up to date with GOV.UK",
      link_href: "/signup-link?topic=/coronavirus-taxon",
      link_text: "Sign up to get emails",
    )
    assert_select ".app-c-signup-link .app-c-signup-link__link[href='/signup-link?topic=/coronavirus-taxon']", text: "Sign up to get emails"
  end

  test "renders optional heading" do
    render_component(
      heading: "Stay up to date with GOV.UK",
      link_href: "/signup-link?topic=/coronavirus-taxon",
      link_text: "Sign up to get emails when we change any coronavirus information on the GOV.UK website",
    )
    assert_select ".app-c-signup-link__title", text: "Stay up to date with GOV.UK"
  end

  test "renders component with custom heading level" do
    render_component(
      heading: "Stay up to date with GOV.UK",
      link_href: "/signup-link?topic=/coronavirus-taxon",
      link_text: "Sign up to get emails when we change any coronavirus information on the GOV.UK website",
      heading_level: 1,
    )
    assert_select "h1.app-c-signup-link__title", text: "Stay up to date with GOV.UK"
  end

  test "renders component with background and border when background is true" do
    render_component(
      link_href: "/coronavirus",
      link_text: "Click here to sign up",
      heading: "Sign up for updates",
      background: true,
    )
    assert_select ".app-c-signup-link--with-background-and-border"
  end

  test "adds data attributes when data attributes are passed" do
    render_component(
      link_href: "/coronavirus",
      link_text: "Click here to sign up",
      heading: "Sign up for updates",
      data: {
        "custom-data-attr": "customVal",
      },
    )
    assert_select ".app-c-signup-link .app-c-signup-link__link[data-custom-data-attr='customVal']"
  end
end
