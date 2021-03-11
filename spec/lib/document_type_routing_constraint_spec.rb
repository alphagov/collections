RSpec.describe DocumentTypeRoutingConstraint do
  describe "#matches?" do
    context "when the content_store returns a document" do
      it "should return true if document_type matches" do
        request = double("request", env: {})

        doc_type = "foo"

        subject = described_class.new(doc_type)
        inspector = instance_double("DocumentTypeInspector", document_type: doc_type)

        allow(subject)
        .to receive(:document_type_inspector)
        .and_return(inspector)

        expect(subject.matches?(request)).to be(true)
      end

      it "should return false if document_type doesn't match" do
        request = double("request", env: {})

        doc_type = "bar"
        request_doc_type = "foo"

        subject = described_class.new(doc_type)
        inspector = instance_double("DocumentTypeInspector", document_type: request_doc_type)

        allow(subject)
        .to receive(:document_type_inspector)
        .and_return(inspector)

        expect(subject.matches?(request)).to be(false)
      end
    end

    context "when the content_store API call throws an error" do
      it "should return false and set an error on the request object" do
        request = double("request", env: {})

        error = GdsApi::HTTPNotFound.new(404)

        subject = described_class.new("foo")
        inspector = instance_double("DocumentTypeInspector", document_type: nil, error: error)

        allow(subject)
        .to receive(:document_type_inspector)
        .and_return(inspector)

        expect(subject.matches?(request)).to be(false)
        expect(request.env[:__api_error]).to eq(error)
      end
    end
  end

  context "instances are memoized and used across multiple requests" do
    it "should make new API calls each time" do
      request1 = double("request", params: { slug: "slug" }, env: {})
      request2 = double("request", params: { slug: "slug" }, env: {})

      doc_type = "foo"

      api_proxy = double("api_proxy", document_type: doc_type)

      subject = described_class.new(doc_type)

      expect(DocumentTypeInspector)
      .to receive(:new)
      .twice
      .and_return(api_proxy)

      subject.matches?(request1)
      subject.matches?(request2)
    end
  end

  context "a request will be passed to multiple instances" do
    it "should not make additional API calls" do
      request = double("request", params: { slug: "slug" }, env: {})

      doc_type1 = "foo"
      doc_type2 = "bar"
      request_doc_type = "baz"

      api_proxy = double("api_proxy", document_type: request_doc_type)

      subject1 = described_class.new(doc_type1)
      subject2 = described_class.new(doc_type2)

      expect(DocumentTypeInspector)
      .to receive(:new)
      .once
      .and_return(api_proxy)

      subject1.matches?(request)
      subject2.matches?(request)
    end
  end
end
