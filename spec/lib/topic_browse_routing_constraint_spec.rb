RSpec.describe TopicBrowseRoutingConstraint do
  let(:test_yaml) do
    { "mappings" =>
      [
        {
          "browse_path" => "/browse/foo",
          "topic_path" => "/topic/bar",
        },
      ] }
  end

  let(:empty_config_yaml) do
    { "mappings" => [] }
  end

  describe "#matches?" do
    context "when a topic browse mapping exists" do
      before do
        allow(YAML).to receive(:load_file).and_return(test_yaml)
      end

      it "should return true if the path matches" do
        request = double("request", path: "/topic/bar")
        subject = described_class.new
        expect(subject.matches?(request)).to be(true)
      end

      it "should return false if the path does not match" do
        request = double("request", path: "/topic/nope")
        subject = described_class.new
        expect(subject.matches?(request)).to be(false)
      end
    end

    context "when there are no browse topic mappings" do
      before do
        allow(YAML).to receive(:load_file).and_return(empty_config_yaml)
      end

      it "should return true if the path matches" do
        request = double("request", path: "/topic/bar")
        subject = described_class.new
        expect(subject.matches?(request)).to be(false)
      end

      it "should return false if the path does not match" do
        request = double("request", path: "/topic/nope")
        subject = described_class.new
        expect(subject.matches?(request)).to be(false)
      end
    end
  end
end
