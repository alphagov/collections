RSpec.describe DitLandingPageController do
  include DitLandingPageHelpers
  render_views

  before do
    stub_all_eubusiness_pages
  end

  describe "GET show" do
    expected_content = {
      de: "Informationen für Unternehmen mit Sitz in der EU, die Handelsbeziehungen mit dem Vereinigten Königreich unterhalten",
      es: "Comerciar con el Reino Unido como empresa con sede en la UE",
      fr: "Travailler avec le Royaume-Uni en tant qu'entreprise basée dans l'UE",
      it: "Se la tua impresa ha sede nell’UE, scopri come continuare a intrattenere scambi commerciali con il Regno Unito",
      nl: "Handel drijven met het VK vanuit een in Europa gevestigde onderneming",
      pl: "Wymiana handlowa z Wielką Brytanią z punktu widzenia firmy z siedzibą w UE",
    }

    expected_content.each_key do |locale|
      it "renders translated page for the #{locale} locale" do
        get :show, params: { locale: locale }
        expect(response).to have_http_status(:success)
        expect(response.body).to have_selector("h1", text: expected_content[locale])
        expect(response.body).to have_selector("main[lang=#{locale}]")
      end
    end

    it "renders the English page" do
      get :show
      expect(response).to have_http_status(:success)
      expect(response.body).to have_selector("h1", text: I18n.t!("dit_landing_page.page_header"))
      expect(response).not_to have_selector("main[lang=en]")
    end
  end
end
