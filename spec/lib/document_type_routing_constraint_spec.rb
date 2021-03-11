RSpec.describe DocumentTypeRoutingConstraint do
  describe "#matches?" do
    context "when the content_store returns a document" do
      it "should return true if document_type matches" do
        instance = instance_double("DocumentTypeInspector")
        subject = document_type_routing_constraint("foo", instance)

        allow(subject)
        .to receive(:document_type_inspector)
        .and_return(instance)

        allow(instance)
        .to receive(:document_type)
        .and_return("foo")

        request = double("request", env: {})

        expect(subject.matches?(request)).to be(true)
      end

      it "should return false if document_type doesn't match" do
        instance = instance_double("DocumentTypeInspector")
        subject = document_type_routing_constraint("bar", instance)

        allow(subject)
        .to receive(:document_type_inspector)
        .and_return(instance)

        allow(instance)
        .to receive(:document_type)
        .and_return("foo")

        request = double("request", env: {})

        expect(subject.matches?(request)).to be(false)
      end
    end

    context "when the content_store API call throws an error" do
      let(:error) { GdsApi::HTTPNotFound.new(404) }

      it "should return false and set an error on the request object" do
        instance = instance_double("DocumentTypeInspector", document_type: nil, error: error)
        subject = document_type_routing_constraint("foo", instance)

        allow(subject)
        .to receive(:document_type_inspector)
        .and_return(instance)

        request = double("request", env: {})

        expect(subject.matches?(request)).to be(false)
        expect(request.env[:__api_error]).to eq(error)
      end
    end
  end

  context "instances are memoized and used across multiple requests" do
    let(:document_type) { "static across requests" }

    it "should make new API calls each time" do
      api_proxy = double("api_proxy")
      inspector = double("inspector", document_type: document_type, error: nil)
      request1 = double("request", params: { slug: "slug" }, env: {})
      request2 = double("request", params: { slug: "slug" }, env: {})
      subject = document_type_routing_constraint("foo", api_proxy)

      expect(api_proxy)
      .to receive(:new)
      .twice
      .and_return(inspector)

      subject.matches?(request1)
      subject.matches?(request2)
    end
  end

  context "a request will be passed to multiple instances" do
    it "should not make additional API calls" do
      instance = instance_double("DocumentTypeInspector", document_type: "baz")
      api_proxy = double("api_proxy", new: instance)
      request = double("request", params: { slug: "slug" }, env: {})

      expect(api_proxy)
      .to receive(:new)
      .once
      .and_return(instance)

      document_type_routing_constraint("foo", api_proxy).matches?(request)
      document_type_routing_constraint("bar", api_proxy).matches?(request)
    end
  end

  def document_type_routing_constraint(doc_type, document_type_inspector)
    described_class.new(
      doc_type,
      document_type_inspector: document_type_inspector,
    )
  end
end
