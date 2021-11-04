require "spec_helper"

RSpec.describe "the nhs notice partial" do
  before do
    render(
      "coronavirus_landing_page/components/landing_page/nhs_notice",
      {
        nhs_banner: {
          header: "Hello world",
          sections: sections,
        },
      }.with_indifferent_access,
    )
  end

  describe "header" do
    context "when there is header text" do
      let(:sections) { [] }

      it "renders the header as an H2 with the text" do
        expect(rendered).to have_selector("h2", text: "Hello world")
      end
    end
  end

  describe "sections" do
    context "when there are no sections" do
      let(:sections) { [] }

      it "renders an empty DIV" do
        expect(rendered).to have_selector("div.govuk-grid-column-two-thirds", text: "")
      end
    end

    describe "markdown" do
      context "when the markdown is empty" do
        let(:sections) { [{ markdown: "" }] }

        it "does not render a DIV with the govuk-govspeak class" do
          expect(rendered).to have_no_selector("div.govuk-govspeak")
        end
      end

      context "when the markdown has text" do
        let(:sections) { [{ markdown: "- List item\n" }] }

        it "renders a DIV with govuk-govspeak" do
          expect(rendered).to have_selector("div.govuk-govspeak")
        end

        it "renders the markdown text as HTML" do
          expect(rendered).to have_selector("li", text: "List item")
        end
      end
    end

    describe "heading" do
      context "when there is a heading but no URL" do
        let(:sections) { [{ heading: "Section heading" }] }

        it "renders an H3 with the heading text" do
          expect(rendered).to have_selector("h3", text: "Section heading")
        end
      end

      context "when there is a heading but the URL is empty" do
        let(:sections) { [{ heading: "Section heading", url: "" }] }

        it "renders a section heading as an H3" do
          expect(rendered).to have_selector("h3", text: "Section heading")
        end
      end

      context "when there is a URL but no heading" do
        let(:sections) do
          [{ url: "https://example.com" }]
        end

        it "does not render a section heading" do
          expect(rendered).to have_no_selector("p.govuk-heading-s")
        end

        it "does not render a link" do
          expect(rendered).to have_no_link("Section heading", href: "https://example.com")
        end
      end

      context "when there is a heading and a URL" do
        let(:sections) do
          [{ heading: "Section heading", url: "https://example.com" }]
        end

        it "renders a P styled as an H3" do
          expect(rendered).to have_selector("p.govuk-heading-s")
        end

        it "renders a link with the heading text" do
          expect(rendered).to have_link("Section heading", href: "https://example.com")
        end
      end
    end
  end
end
