RSpec.describe MinistersIndexHelper do
  describe "role_link" do
    it "returns a link element with govuk-link style" do
      role = double(title: "Minister of Walks", url: "an-url")
      expect(helper.role_link(role)).to eql("<a class=\"govuk-link\" href=\"an-url\">Minister of Walks</a>")
    end
  end

  describe "cabinet_minister_description" do
    before { allow(helper).to receive(:joined_list).and_return("joined list") }

    context "when the minister has no footnotes" do
      let(:minister) { double(roles: [], role_payment_info: []) }

      it "returns a paragraph with the minister's roles as a joined list" do
        expect(helper.cabinet_minister_description(minister)).to eql("<p>joined list</p>")
      end
    end

    context "when the minister has footnotes" do
      let(:minister) { double(roles: [], role_payment_info: %w[one two]) }

      it "returns a paragraph with the minister's roles as a joined list and the roles as a span with the footnotes class" do
        expect(helper.cabinet_minister_description(minister)).to eql("<p>joined list<span class=\"footnotes\">one. two</span></p>")
      end
    end
  end
end
