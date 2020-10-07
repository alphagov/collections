require "spec_helper"

describe "lookup", type: :view do
  def component_name
    "lookup"
  end

  def render_component(locals)
    if block_given?
      render("components/#{component_name}", locals) { yield }
    else
      render "components/#{component_name}", locals
    end
  end

  it "displays external link" do
    render_component(link: { text: "Find a postcode on Royal Mail", href: "royalmail.com/share" })
    assert_select ".govuk-link--external"
    assert_select ".govuk-link.govuk-link--external", text: "Find a postcode on Royal Mail"
    assert_select ".govuk-link.govuk-link--external", href: /royalmail\.com\/share/
  end

  it "displays inline input error alert" do
    render_component(error_message: "error message", input_error: "input error")
    assert_select ".gem-c-error-message", text: "Error: input error"
    assert_select ".gem-c-error-alert"
  end

  it "displays error alert box" do
    render_component(error_message: "This isn't a valid postcode.", error_description: "Check it and enter it again.")
    assert_select ".gem-c-error-alert"
    assert_select ".gem-c-error-summary__title", text: "This isn't a valid postcode."
    assert_select ".gem-c-error-summary__body", text: "Check it and enter it again."
  end

  it "has lookup question" do
    render_component(input_label: "Enter a postcode")
    assert_select "label.gem-c-label.govuk-label.govuk-label--s", text: "Enter a postcode"
  end

  it "missing lookup question" do
    render_component(input_label: "Enter a postcode")
    assert_select "label.gem-c-label.govuk-label.govuk-label--s", text: "Enter a postcode"
  end

  it "contains lookup hint text" do
    render_component(hint_text: "For example SW1A 2AA")
    assert_select ".govuk-hint", text: "For example SW1A 2AA"
  end

  it "contains lookup button and text" do
    render_component(button_text: "Find")
    assert_select ".gem-c-button", text: "Find"
  end

  it "contains autocomplete" do
    render_component(autocomplete: "postcode")
    assert_select ".gem-c-input.govuk-input"
    assert_select ".gem-c-input.govuk-input", autocomplete: "postcode"
  end
end
