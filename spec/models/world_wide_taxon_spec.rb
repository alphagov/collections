RSpec.describe WorldWideTaxon do
  include TaxonHelpers

  let(:content_item) { ContentItem.new(student_finance_taxon) }
  subject { WorldWideTaxon.new(content_item) }

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
      taxon_without_phase = described_class.new(content_item)

      expect { taxon_without_phase.phase }.to raise_error(RuntimeError)
    end

    it "checks if content is live" do
      expect(subject.live_taxon?).to be(true)
    end

    it "has two taxon children" do
      expect(subject.child_taxons.length).to eq(2)

      subject.child_taxons.each do |child|
        expect(child).to be_an_instance_of(WorldWideTaxon)
        expect(["Student sponsorship", "Student loans"]).to include(child.title)
      end
    end
  end

  context "with associated_taxons" do
    let(:content_item) { ContentItem.new(travelling_to_the_usa_taxon) }

    it "retrieves content tagged to itself and associated_taxons" do
      own_content_id = subject.content_id
      associated_taxon_content_id = "36dd87da-4973-5490-ab00-72025b1da506"

      expect(TaggedContent)
        .to receive(:fetch)
        .with([own_content_id, associated_taxon_content_id])
        .and_return(["own content", "associated content"])

      expect(subject.tagged_content).to eq(["own content", "associated content"])
    end
  end
end
