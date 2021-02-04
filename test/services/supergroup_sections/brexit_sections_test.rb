require "test_helper"

describe SupergroupSections::BrexitSections do
  include SearchApiHelpers
  include TaxonHelpers

  let(:taxon_id) { "12345" }
  let(:base_path) { "/base/path" }
  let(:brexit_supergroup_sections) do
    SupergroupSections::BrexitSections.new(taxon_id, base_path).sections
  end

  describe "#sections" do
    it "returns a list of supergroup details for the brexit page" do
      sections_hash = [
        {
          name: "services",
          title: "Services",
          see_more_link: {
            text: "See more services in this topic",
            url: "/search/services?parent=%2Fbase%2Fpath&topic=12345",
            data: {
              track_category: "SeeAllLinkClicked",
              track_action: "/base/path",
              track_label: "services",
              module: "track-click",
            },
          },
        },
        {
          name: "guidance_and_regulation",
          title: "Guidance and regulation",
          see_more_link: {
            text: "See more guidance and regulation in this topic",
            url: "/search/guidance-and-regulation?parent=%2Fbase%2Fpath&topic=12345",
            data: {
              track_category: "SeeAllLinkClicked",
              track_action: "/base/path",
              track_label: "guidance_and_regulation",
              module: "track-click",
            },
          },
        },
        {
          name: "news_and_communications",
          title: "News and communications",
          see_more_link:
            {
              text: "See more news and communications in this topic",
              url: "/search/news-and-communications?parent=%2Fbase%2Fpath&topic=12345",
              data: {
                track_category: "SeeAllLinkClicked",
                track_action: "/base/path",
                track_label: "news_and_communications",
                module: "track-click",
              },
            },
        },
        {
          name: "research_and_statistics",
          title: "Research and statistics",
          see_more_link: {
            text: "See more research and statistics in this topic",
            url: "/search/research-and-statistics?parent=%2Fbase%2Fpath&topic=12345",
            data: {
              track_category: "SeeAllLinkClicked",
              track_action: "/base/path",
              track_label: "research_and_statistics",
              module: "track-click",
            },
          },
        },
        {
          name: "policy_and_engagement",
          see_more_link: {
            text: "See more policy papers and consultations in this topic",
            url: "/search/policy-papers-and-consultations?parent=%2Fbase%2Fpath&topic=12345",
            data: {
              track_category: "SeeAllLinkClicked",
              track_action: "/base/path",
              track_label: "policy_and_engagement",
              module: "track-click",
            },
          },
          title: "Policy and engagement",
        },
        {
          name: "transparency",
          title: "Transparency",
          see_more_link: {
            text: "See more transparency and freedom of information releases in this topic",
            url: "/search/transparency-and-freedom-of-information-releases?parent=%2Fbase%2Fpath&topic=12345",
            data: {
              track_category: "SeeAllLinkClicked",
              track_action: "/base/path",
              track_label: "transparency",
              module: "track-click",
            },
          },
        },
      ]
      assert_equal brexit_supergroup_sections, sections_hash
    end
  end
end
