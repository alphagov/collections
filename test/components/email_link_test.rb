require 'component_test_helper'

class EmailLinkTest < ComponentTestCase
  def component_name
    "email-link"
  end

  test "renders nothing without a href" do
    assert_empty render_component(
      text: 'Sign up for email'
    )
  end

  test "renders nothing without text" do
    assert_empty render_component(
      href: '/email'
    )
  end

  test "renders nothing with no input" do
    assert_empty render_component({})
  end

  test "renders correct link when given a href and text" do
    render_component(
      text: 'Get alerts',
      href: '/email'
    )

    assert_select ".app-c-email-link[href='/email']", text: 'Get alerts'
  end
end
