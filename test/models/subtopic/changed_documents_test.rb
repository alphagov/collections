require "test_helper"

describe Subtopic::ChangedDocuments do
  include RummagerHelpers

  def expect_search_params(params)
    GdsApi::Rummager.any_instance.expects(:unified_search)
      .with(has_entries(params))
      .returns(:some_results)
  end

  describe "constructing the query params" do
    setup do
      @subtopic_slug = 'business-tax/paye'
      @pagination_options = {}
      @documents = Subtopic::ChangedDocuments.new(@subtopic_slug, @pagination_options)
    end

    it "filters for the given subtopic" do
      expect_search_params(:filter_specialist_sectors => [@subtopic_slug])
      @documents.send(:search_result)
    end

    it "sorts by public_timestamp, newest first" do
      expect_search_params(:order => "-public_timestamp")
      @documents.send(:search_result)
    end

    it "requests the necessary fields" do
      expect_search_params(:fields => %w(title link latest_change_note public_timestamp))
      @documents.send(:search_result)
    end

    describe "page start value" do
      it "starts at 0 by default" do
        expect_search_params(:start => 0)
        @documents.send(:search_result)
      end

      it "uses the given start value" do
        @pagination_options[:start] = "12"
        expect_search_params(:start => 12)
        @documents.send(:search_result)
      end

      it "starts at 0 when given garbage" do
        @pagination_options[:start] = "foo"
        expect_search_params(:start => 0)
        @documents.send(:search_result)
      end

      it "starts at 0 when given negative value" do
        @pagination_options[:start] = "-1"
        expect_search_params(:start => 0)
        @documents.send(:search_result)
      end
    end

    describe "page size" do

      it "uses a page size of 50 by default" do
        expect_search_params(:count => 50)
        @documents.send(:search_result)
      end

      it "uses the given page size" do
        @pagination_options[:count] = "42"
        expect_search_params(:count => 42)
        @documents.send(:search_result)
      end

      it "caps the page size at 100" do
        @pagination_options[:count] = "142"
        expect_search_params(:count => 100)
        @documents.send(:search_result)
      end

      it "uses the default page size when given garbage" do
        @pagination_options[:count] = "foo"
        expect_search_params(:count => 50)
        @documents.send(:search_result)
      end

      it "uses the default page size when given a negative value" do
        @pagination_options[:count] = "-1"
        expect_search_params(:count => 50)
        @documents.send(:search_result)
      end
    end
  end

  describe "with a single page of results available" do
    setup do
      @subtopic_slug = 'business-tax/paye'
      rummager_has_latest_documents_for_subtopic(@subtopic_slug, [
        'pay-paye-penalty',
        'pay-paye-tax',
        'pay-psa',
        'employee-tax-codes',
        'payroll-annual-reporting',
      ])
    end

    it "returns the latest documents for the subtopic" do
      expected_titles = [
        'Pay Paye Penalty',
        'Pay Paye Tax',
        'Pay Psa',
        'Employee Tax Codes',
        'Payroll Annual Reporting',
      ]
      assert_equal expected_titles, Subtopic::ChangedDocuments.new(@subtopic_slug).map(&:title)
    end

    it "provides the title, base_path and change_note for each document" do
      documents = Subtopic::ChangedDocuments.new(@subtopic_slug).to_a

      # Actual values come from rummager helpers.
      assert_equal "/government/publications/pay-psa", documents[2].base_path
      assert_equal "Employee Tax Codes", documents[3].title
      assert_equal "This has changed", documents[4].change_note
    end

    it "provides the public_updated_at for each document" do
      documents = Subtopic::ChangedDocuments.new(@subtopic_slug).to_a

      assert documents[0].public_updated_at.is_a?(Time)

      # Document timestamp value set in rummager helpers
      assert_in_epsilon 1.hour.ago.to_i, documents[0].public_updated_at.to_i, 5
    end
  end

  describe "with multiple pages of results available" do
    setup do
      @subtopic_slug = 'business-tax/paye'
      rummager_has_latest_documents_for_subtopic(@subtopic_slug, [
        'pay-paye-penalty',
        'pay-paye-tax',
        'pay-psa',
        'employee-tax-codes',
        'payroll-annual-reporting',
      ], :page_size => 3)
      @pagination_options = {:count => 3}
      @documents = Subtopic::ChangedDocuments.new(@subtopic_slug, @pagination_options)
    end

    it "returns the first page of results" do
      expected_titles = [
        'Pay Paye Penalty',
        'Pay Paye Tax',
        'Pay Psa',
      ]
      assert_equal expected_titles, @documents.map(&:title)
    end

    it "returns the requested page of results" do
      @pagination_options[:start] = 3
      expected_titles = [
        'Employee Tax Codes',
        'Payroll Annual Reporting',
      ]
      assert_equal expected_titles, @documents.map(&:title)
    end
  end

  describe "handling missing fields in the search results" do
    it "handles documents that don't contain the public_timestamp field" do
      result = rummager_latest_document_for_slug('pay-psa')
      result.delete("public_timestamp")

      Collections::Application.config.search_client.stubs(:unified_search).with(
        has_entries(filter_specialist_sectors: ['business-tax/paye'])
      ).returns({
        "results" => [result],
        "start" => 0,
        "total" => 1,
      })

      documents = Subtopic::ChangedDocuments.new("business-tax/paye")
      assert_equal 1, documents.to_a.size
      assert_equal 'Pay Psa', documents.first.title
      assert_nil documents.first.public_updated_at
    end
  end
end
