RSpec.describe DocumentTypeInspector do
  subject { described_class.new(:slug) }

  context "content-store lookup throws an error" do
    let(:error) { GdsApi::HTTPNotFound.new("asd") }

    before do
      allow(Services)
      .to receive(:content_store)
      .and_raise(error)
    end

    describe "#document_type" do
      it "should return nil" do
        expect(subject.document_type).to be_nil
      end
    end

    describe "#error" do
      it "should return the error" do
        subject.document_type
        expect(subject.error).to be(error)
      end
    end
  end
end
