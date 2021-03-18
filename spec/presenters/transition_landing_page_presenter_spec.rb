require "test_helper"

describe TransitionLandingPagePresenter do
  before :each do
    YAML.stubs(:load_file).returns(yaml_contents)
  end

  let(:yaml_contents) do
    [
      {
        "list_block" => "<p>This is some text</p>",
      },
    ]
  end

  subject do
    TransitionLandingPagePresenter.new(taxon)
  end

  let(:taxon) { Taxon.new(ContentItem.new("content_id" => "content_id", "base_path" => "/base_path")) }

  describe "#supergroup_sections" do
    it "returns the presented supergroup sections" do
      result_hash = [
        {
          text: "Services",
          path: "/search/services?parent=%2Fbase_path&topic=content_id",
          aria_label: "Services related to Brexit",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "services",
            module: "gem-track-click",
          },
        },
        {
          text: "Guidance and regulation",
          path: "/search/guidance-and-regulation?parent=%2Fbase_path&topic=content_id",
          aria_label: "Guidance and regulation related to Brexit",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "guidance_and_regulation",
            module: "gem-track-click",
          },
        },
        {
          text: "News and communications",
          path: "/search/news-and-communications?parent=%2Fbase_path&topic=content_id",
          aria_label: "News and communications related to Brexit",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "news_and_communications",
            module: "gem-track-click",
          },
        },
        {
          text: "Research and statistics",
          path: "/search/research-and-statistics?parent=%2Fbase_path&topic=content_id",
          aria_label: "Research and statistics related to Brexit",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "research_and_statistics",
            module: "gem-track-click",
          },
        },
        {
          text: "Policy papers and consultations",
          path: "/search/policy-papers-and-consultations?parent=%2Fbase_path&topic=content_id",
          aria_label: "Policy papers and consultations related to Brexit",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "policy_and_engagement",
            module: "gem-track-click",
          },
        },
        {
          text: "Transparency and freedom of information releases",
          path: "/search/transparency-and-freedom-of-information-releases?parent=%2Fbase_path&topic=content_id",
          aria_label: "Transparency and freedom of information releases related to Brexit",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "transparency",
            module: "gem-track-click",
          },
        },
      ]
      assert_equal subject.supergroup_sections, result_hash
    end
  end

  describe "#email_path" do
    it "strips the locale extension from the base path if present" do
      I18n.with_locale(:cy) do
        taxon = Taxon.new(ContentItem.new("base_path" => "/base_path.cy"))
        subject = TransitionLandingPagePresenter.new(taxon)
        assert_equal "/base_path", subject.email_path
      end
    end
  end
end
