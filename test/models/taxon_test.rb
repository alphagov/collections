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

    it 'knows about its most popular content items' do
      results = [:result_1, :result_2]
      MostPopularContent.stubs(:fetch).returns(results)

      assert_equal(results, @taxon.most_popular_content)
    end

    it "requests popular content of document supertype 'guidance' by default" do
      results = [:result_1, :result_2]
      MostPopularContent.stubs(:fetch)
        .with(content_id: @taxon.content_id, filter_by_document_supertype: 'guidance')
        .returns(results)

      assert_equal(results, @taxon.most_popular_content)
    end

    it "does not request popular content of document supertype 'guidance' for world related content" do
      @taxon.stubs(base_path: "/world/brazil")

      results = [:result_1, :result_2]
      MostPopularContent.stubs(:fetch)
        .with(content_id: @taxon.content_id, filter_by_document_supertype: nil)
        .returns(results)

      assert_equal(results, @taxon.most_popular_content)
    end

    it 'requests for guidance document supertype by default' do
      TaggedContent.expects(:fetch)
        .with([@taxon.content_id], filter_by_document_supertype: 'guidance', validate: true)
        .returns(["guidance_content"])

      assert_equal ["guidance_content"], @taxon.tagged_content
    end

    it 'does not request guidance document supertype for world related content' do
      @taxon.stubs(base_path: "/world/brazil")

      TaggedContent.expects(:fetch)
        .with([@taxon.content_id], filter_by_document_supertype: nil, validate: false)
        .returns(["brazil_content"])

      assert_equal ["brazil_content"], @taxon.tagged_content
    end
  end

  context "with associated_taxons" do
    setup do
      content_item = ContentItem.new(travelling_to_the_usa_taxon)
      @taxon = Taxon.new(content_item)
    end

    it "retrieves content tagged to itself and associated_taxons" do
      own_content_id = @taxon.content_id
      associated_taxon_content_id = "36dd87da-4973-5490-ab00-72025b1da506"

      TaggedContent.expects(:fetch)
        .with([own_content_id, associated_taxon_content_id], filter_by_document_supertype: nil, validate: false)
        .returns(["own content", "associated content"])

      assert_equal ["own content", "associated content"],
        @taxon.tagged_content
    end
  end
end
