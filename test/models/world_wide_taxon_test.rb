require 'test_helper'

describe WorldWideTaxon do
  include TaxonHelpers

  context "without associate_taxons" do
    setup do
      content_item = ContentItem.new(student_finance_taxon)
      @taxon = WorldWideTaxon.new(content_item)
    end

    it 'has a title' do
      assert_equal @taxon.title, student_finance_taxon['title']
    end

    it 'has a description' do
      assert_equal @taxon.description, student_finance_taxon['description']
    end

    it 'has a content id' do
      assert_equal @taxon.content_id, student_finance_taxon['content_id']
    end

    it 'has a base path' do
      assert_equal @taxon.base_path, student_finance_taxon['base_path']
    end

    it 'has a phase' do
      assert_equal @taxon.phase, student_finance_taxon['phase']
    end

    it 'errors if phase is not found' do
      student_finance_taxon_without_phase = student_finance_taxon
      student_finance_taxon_without_phase.delete('phase')

      content_item = ContentItem.new(student_finance_taxon_without_phase)
      @taxon_without_phase = WorldWideTaxon.new(content_item)

      assert_raises(RuntimeError) { @taxon_without_phase.phase }
    end

    it 'checks if content is live' do
      assert(@taxon.live_taxon?)
    end

    it 'has two taxon children' do
      assert_equal @taxon.child_taxons.length, 2

      @taxon.child_taxons.each do |child|
        assert_includes ['Student sponsorship', 'Student loans'], child.title
      end
    end
  end

  context "with associated_taxons" do
    setup do
      content_item = ContentItem.new(travelling_to_the_usa_taxon)
      @taxon = WorldWideTaxon.new(content_item)
    end

    it "retrieves content tagged to itself and associated_taxons" do
      own_content_id = @taxon.content_id
      associated_taxon_content_id = "36dd87da-4973-5490-ab00-72025b1da506"

      TaggedContent.expects(:fetch)
        .with([own_content_id, associated_taxon_content_id], filter_by_document_supertype: nil)
        .returns(["own content", "associated content"])

      assert_equal ["own content", "associated content"],
        @taxon.tagged_content
    end
  end
end
