RSpec.describe TopicBrowseHelper do
  let(:test_yaml) do
    { "mappings" =>
      [
        {
          "browse_path" => "foo",
          "topic_path" => "bar",
        },
      ] }
  end

  before do
    allow(YAML).to receive(:load_file).and_return(test_yaml)
  end

  describe "#topic_browse_mapping" do
    it "returns the topic mapping for a given browse base path" do
      expect(topic_browse_mapping("boo")).to be nil
      expect(topic_browse_mapping("foo")).to eq({ "browse_path" => "foo", "topic_path" => "bar" })
    end

    it "returns the topic mapping for a given topic base path" do
      expect(topic_browse_mapping("boo")).to be nil
      expect(topic_browse_mapping("bar")).to eq({ "browse_path" => "foo", "topic_path" => "bar" })
    end
  end
end
