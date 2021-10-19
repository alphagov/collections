RSpec.describe Taxon do
  include TaxonHelpers

  let(:content_item) { ContentItem.new(student_finance_taxon) }
  subject { described_class.new(content_item) }

  context "without associate_taxons" do
    it "has a title" do
      expect(student_finance_taxon["title"]).to eq(subject.title)
    end

    it "has a description" do
      expect(student_finance_taxon["description"]).to eq(subject.description)
    end

    it "has a content id" do
      expect(student_finance_taxon["content_id"]).to eq(subject.content_id)
    end

    it "has a base path" do
      expect(student_finance_taxon["base_path"]).to eq(subject.base_path)
    end

    it "has a phase" do
      expect(student_finance_taxon["phase"]).to eq(subject.phase)
    end

    it "errors if phase is not found" do
      student_finance_taxon_without_phase = student_finance_taxon
      student_finance_taxon_without_phase.delete("phase")

      content_item = ContentItem.new(student_finance_taxon_without_phase)
      taxon_without_phase = Taxon.new(content_item)

      expect { taxon_without_phase.phase }.to raise_error(RuntimeError)
    end

    it "checks if content is live" do
      expect(subject.live_taxon?).to be(true)
    end

    it "has two taxon children" do
      expect(subject.child_taxons.length).to eq(2)

      subject.child_taxons.each do |child|
        expect(child).to be_an_instance_of(Taxon)
        expect(["Student sponsorship", "Student loans"]).to include(child.title)
      end
    end

    it "presents the override url" do
      taxon_with_url_override = build_taxon(student_taxon_with_url_override)

      expect(taxon_with_url_override.preferred_url).to eq("/override_url")
    end

    it "presents the base path if there isn't an override url" do
      taxon_without_url_override = build_taxon(student_finance_taxon_without_url_override)

      expect(taxon_without_url_override.preferred_url).to eq(taxon_without_url_override.base_path)
    end
  end

  def build_taxon(content_hash)
    content_item = ContentItem.new(content_hash)
    Taxon.new(content_item)
  end

  def student_taxon_with_url_override
    student_finance_taxon({
      "details" => {
        "url_override" => "/override_url",
      },
    })
  end

  def student_finance_taxon_without_url_override
    student_finance_taxon.tap do |taxon|
      taxon["details"].delete("url_override")
    end
  end

  context "with a child in the alpha phase" do
    let(:content_item) do
      ContentItem.new(
        student_finance_taxon(
          "links" => {
            "child_taxons" => [
              student_sponsorship_taxon(
                "title" => "Foo",
                "phase" => "live",
                "base_path" => "/topic/business-tax/foo",
              ),
              student_loans_taxon(
                "title" => "Bar",
                "phase" => "alpha",
                "base_path" => "/topic/business-tax/bar",
              ),
            ],
          },
        ),
      )
    end

    it "ignores children in the alpha phase" do
      expect(subject.child_taxons[0].title).to eq("Foo")
      expect(subject.child_taxons.length).to eq(1)
    end
  end
end
