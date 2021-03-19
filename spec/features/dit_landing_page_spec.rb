require "integration_test_helper"

feature "Dit landing page" do
  include DitLandingPageHelpers

  describe "the DIT landing page" do
    before do
      stub_dit_landing_page
    end
    it "renders" do
      when_i_visit_the_dit_landing_page
      then_i_can_see_the_header_section
      and_i_can_see_the_guidance_links
      then_i_can_see_the_training_section
    end

    context "in a different locale" do
      before do
        stub_all_eubusiness_pages
      end
      it "displays the translated content" do
        when_i_visit_the_dit_landing_page
        then_i_can_see_the_translation_nav
        and_i_click_on_deutsch
        then_i_see_the_german_translation_of_the_page
        and_i_click_on_english
        then_i_can_see_the_english_translation_of_the_page
      end
    end
  end

  # test 1
  def when_i_visit_the_dit_landing_page
    visit DIT_LANDING_PAGE_PATH
  end

  def then_i_can_see_the_header_section
    expect(page.has_title?(I18n.t!("dit_landing_page.page_header"))).to be
  end

  def and_i_can_see_the_guidance_links
    expect(page.has_selector?("h3", text: "Import from the UK")).to be
  end

  def then_i_can_see_the_training_section
    expect(page.has_selector?("h2", text: I18n.t!("dit_landing_page.training_section_title"))).to be
  end

  # test 2
  def then_i_can_see_the_translation_nav
    expect(page.has_selector?("nav", text: "Deutsch")).to be
  end

  def and_i_click_on_deutsch
    click_on("Deutsch")
  end

  def then_i_see_the_german_translation_of_the_page
    expect(page.has_title?("Informationen für Unternehmen mit Sitz in der EU, die Handelsbeziehungen mit dem Vereinigten Königreich unterhalten")).to be
  end

  def and_i_click_on_english
    click_on("English")
  end

  def then_i_can_see_the_english_translation_of_the_page
    then_i_can_see_the_header_section
  end
end
