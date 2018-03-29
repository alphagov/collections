require 'component_test_helper'

class AccordionTest < ComponentTestCase
  def component_name
    "accordion"
  end

  def simple_accordion
    [
      {
        title: 'General information and guidance',
        panel: '1st panel contents'
      },
      {
        title: 'Alternative provision censuses',
        panel: '2nd panel contents'
      }
    ]
  end

  section1 = ".app-c-accordion__section:nth-child(1)"
  section2 = ".app-c-accordion__section:nth-child(2)"

  test "renders nothing without passed content" do
    assert_empty render_component({})
  end

  test "renders an accordion correctly" do
    render_component(sections: simple_accordion)
    assert_select ".app-c-accordion"

    assert_select section1 + "#general-information-and-guidance"
    assert_select section1 + " .app-c-accordion__title", text: "General information and guidance"
    assert_select section1 + " .app-c-accordion__panel", text: "1st panel contents"

    assert_select section2 + "#alternative-provision-censuses"
    assert_select section2 + " .app-c-accordion__title", text: "Alternative provision censuses"
    assert_select section2 + " .app-c-accordion__panel", text: "2nd panel contents"
  end

  test "renders accordion with description in a header" do
    descriptions_accordion = simple_accordion
    descriptions_accordion[0][:description] = "1st section description"

    render_component(sections: descriptions_accordion)

    assert_select ".app-c-accordion__header:nth-child(1) .app-c-accordion__description", text: "1st section description"
    assert_select ".app-c-accordion__header:nth-child(2) .app-c-accordion__description", false
  end

  test "renders an accordion with custom section ids" do
    ids_accordion = simple_accordion
    ids_accordion[0][:id] = "first-section-id"

    render_component(sections: ids_accordion)

    assert_select section1 + "#first-section-id"
    assert_select section2 + "#alternative-provision-censuses"
  end

  test "renders an accordion with plus minus icons on the left" do
    render_component(sections: simple_accordion, controls_on_left: true)

    assert_select ".app-c-accordion.app-c-accordion--controls-on-left"
  end
end
