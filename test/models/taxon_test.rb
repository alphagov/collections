require 'test_helper'

describe Taxon do
  include TaxonHelpers

  context "without associate_taxons" do
    setup do
      content_item = ContentItem.new(student_finance_taxon)
      @taxon = Taxon.new(content_item)
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
      @taxon_without_phase = Taxon.new(content_item)

      assert_raises(RuntimeError) { @taxon_without_phase.phase }
    end

    it 'checks if content is live' do
      assert(@taxon.live_taxon?)
    end

    it 'has two taxon children' do
      assert_equal @taxon.child_taxons.length, 2

      @taxon.child_taxons.each do |child|
        assert_instance_of Taxon, child
        assert_includes ['Student sponsorship', 'Student loans'], child.title
      end
    end

    it 'has grandchildren' do
      taxon = stub(children?: true)
      Taxon.stubs(:find).returns(taxon)

      assert @taxon.grandchildren?
    end

    it 'does not have grandchildren' do
      taxon = stub(children?: false)
      Taxon.stubs(:find).returns(taxon)

      assert not(@taxon.grandchildren?)
    end

    it 'knows about its most popular content items' do
      results = [:result_1, :result_2]
      MostPopularContent.stubs(:fetch).returns(results)

      assert_equal(results, @taxon.most_popular_content)
    end

    it "requests popular content of document supertype 'guidance' by default" do
      results = [:result_1, :result_2]
      MostPopularContent.stubs(:fetch)
        .with(content_id: @taxon.content_id, filter_content_purpose_supergroup: 'guidance_and_regulation')
        .returns(results)

      assert_equal(results, @taxon.most_popular_content)
    end

    it 'requests for guidance document supertype by default' do
      TaggedContent.expects(:fetch)
        .with([@taxon.content_id], filter_by_document_supertype: 'guidance', validate: true)
        .returns(["guidance_content"])

      assert_equal ["guidance_content"], @taxon.tagged_content
    end
  end
end
