require "component_test_helper"

class TaxonListTest < ComponentTestCase
  def component_name
    "taxon-list"
  end

  test "renders nothing without a list of items" do
    assert_empty render_component({})
  end

  test "renders a list item with text, path and description" do
    render_component(
      items: [
        {
          text: "Care to Learn",
          path: "/care-to-learn",
          description: "Care to Learn helps pay for childcare while you're studying",
        },
      ],
    )

    assert_select ".app-c-taxon-list__link[href='/care-to-learn']", text: "Care to Learn"
    assert_select ".app-c-taxon-list__description", text: "Care to Learn helps pay for childcare while you're studying"
  end

  test "renders multiple list items" do
    render_component(
      items: [
        {
          text: "Care to Learn",
          path: "/care-to-learn",
          description: "Care to Learn helps pay for childcare while you're studying",
        },
        {
          text: "Childcare Grant",
          path: "/childcare-grant",
          description: "Childcare Grants for full-time students in higher education",
        },
      ],
    )

    assert_select ".app-c-taxon-list__heading .app-c-taxon-list__link[href='/care-to-learn']", text: "Care to Learn"
    assert_select ".app-c-taxon-list__description", text: "Care to Learn helps pay for childcare while you're studying"
    assert_select ".app-c-taxon-list__link[href='/childcare-grant']", text: "Childcare Grant"
    assert_select ".app-c-taxon-list__description", text: "Childcare Grants for full-time students in higher education"
  end

  test "renders a list item with no description" do
    render_component(
      items: [
        {
          text: "Childcare Grant",
          path: "/childcare-grant",
        },
      ],
    )

    assert_select ".app-c-taxon-list__heading .app-c-taxon-list__link[href='/childcare-grant']", false, "List item with no description should not be rendered inside a heading element"
    assert_select ".app-c-taxon-list__link[href='/childcare-grant']", text: "Childcare Grant"
  end

  test "renders a list item with custom heading level" do
    render_component(
      heading_level: 3,
      items: [
        {
          text: "Adult Dependants' Grant",
          path: "/adult-dependants-grant",
          description: "Adult Dependants' Grant for full-time students who financially support an adult",
        },
      ],
    )

    assert_select "h3.app-c-taxon-list__heading"
    assert_select "h3.app-c-taxon-list__heading .app-c-taxon-list__link[href='/adult-dependants-grant']", text: "Adult Dependants' Grant"
  end

  test "renders a list item without a heading if heading_level is 0" do
    render_component(
      heading_level: 0,
      items: [
        {
          text: "Adult Dependants' Grant",
          path: "/adult-dependants-grant",
          description: "Adult Dependants' Grant for full-time students who financially support an adult",
        },
      ],
    )

    assert_select "h3.app-c-taxon-list__heading", false
    assert_select ".app-c-taxon-list__item > .app-c-taxon-list__link[href='/adult-dependants-grant']", text: "Adult Dependants' Grant"
    assert_select ".app-c-taxon-list__description", text: "Adult Dependants\' Grant for full-time students who financially support an adult"
  end

  test "defaults heading to h2 if heading level is out of range" do
    render_component(
      heading_level: 9,
      items: [
        {
          text: "Adult Dependants' Grant",
          path: "/adult-dependants-grant",
          description: "Adult Dependants' Grant for full-time students who financially support an adult",
        },
      ],
    )

    assert_select "h2.app-c-taxon-list__heading", text: "Adult Dependants\' Grant"
  end

  test "renders a list item with data attribute" do
    render_component(
      heading_level: 3,
      items: [
        {
          text: "Childcare Grant",
          path: "/childcare-grant",
          description: "Childcare Grants for full-time students in higher education",
          data_attributes: {
            "ecommerce-row": true,
            track_category: "trackCategory",
            track_action: 1.1,
            track_label: "/track-path",
            track_options: {
              dimension28: 2,
              dimension29: "Environmental taxes, reliefs and schemes for businesses",
            },
          },
        },
      ],
    )

    assert_select ".app-c-taxon-list__link[data-track-category=trackCategory]"
    assert_select ".app-c-taxon-list__link[data-ecommerce-row=true]"
  end
end
