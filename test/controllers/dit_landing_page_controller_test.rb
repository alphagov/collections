require "test_helper"

describe DitLandingPageController do
  describe "GET show" do
    expected_content = {
      de: "Handel mit dem Vereinigten Königreich ab 1. Januar 2021 als Unternehmen mit Sitz in der EU",
      en: "Trade with the UK from 1 January 2021 as a business based in the EU",
      es: "Cómo hacer negocios con el Reino Unido a partir del 1 de enero de 2021 en caso de ser una empresa con sede en la UE",
      fr: "Travailler avec le Royaume-Uni à partir du 1er janvier 2021 en tant qu'entreprise basée dans l'UE",
      it: "Fai affari con il Regno Unito dal 1° gennaio 2021 in qualità di azienda con sede nell’UE",
      nl: "Handel drijven met het Verenigd Koninkrijk vanuit een in Europa gevestigde onderneming vanaf 1 januari 2021",
      pl: "Handel z Wielką Brytanią od 1 stycznia 2021 roku – informacje dla firm z Unii Europejskiej",
    }

    expected_content.each_key do |locale|
      it "renders the page for the #{locale} locale" do
        get :show, params: { locale: locale.to_s }
        assert_response :success
        assert_select "h1", expected_content[locale]
      end
    end
  end
end
