require 'test_helper'

describe BrexitLandingPagePresenter do
  before :each do
    YAML.stubs(:load_file).returns(yaml_contents)
  end

  let(:yaml_contents) {
    [
      {
        'id' => 'id1',
        'items' => [
          {
            'text' => 'text1',
            'description' => '<h1>description1</h1>'
          },
          {
            'text' => 'text2',
            'description' => '<h1>description2</h1>'
          }
        ]
      },
      {
        'id' => 'id2',
        'items' => [
          {
            'text' => 'text3',
            'description' => '<h1>description3</h1>'
          }
        ]
      },
      {
        'id' => 'id3',
        'block' => "text"
      }
    ]
  }

  subject {
    BrexitLandingPagePresenter.new(taxon)
  }

  let(:taxon) { Taxon.new(ContentItem.new('content_id' => 'content_id', 'base_path' => '/base_path')) }

  describe '#buckets' do
    it 'symbolises the items keys' do
      assert(subject.buckets.dig(0, 'items', 0).keys.all? { |key| key.is_a?(Symbol) })
      assert(subject.buckets.dig(0, 'items', 1).keys.all? { |key| key.is_a?(Symbol) })
      assert(subject.buckets.dig(1, 'items', 0).keys.all? { |key| key.is_a?(Symbol) })
    end
    it 'html-safes the descriptions' do
      assert subject.buckets.dig(0, 'items', 0, :description).html_safe?
      assert subject.buckets.dig(0, 'items', 1, :description).html_safe?
      assert subject.buckets.dig(1, 'items', 0, :description).html_safe?
    end
    it 'html-safes the block' do
      assert subject.buckets.dig(2, 'block').html_safe?
    end
  end

  describe '#supergroup_sections' do
    it 'returns the presented supergroup sections' do
      result_hash = [
        {
          text: "Services",
          path: "/search/services?parent=%2Fbase_path&topic=content_id",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "services",
            module: "track-click"
          }
        },
        {
          text: "Guidance and regulation",
          path: "/search/guidance-and-regulation?parent=%2Fbase_path&topic=content_id",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "guidance_and_regulation",
            module: "track-click"
          }
        },
        {
          text: "News and communications",
          path: "/search/news-and-communications?parent=%2Fbase_path&topic=content_id",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "news_and_communications",
            module: "track-click"
          }
        },
        {
          text: "Research and statistics",
          path: "/search/research-and-statistics?parent=%2Fbase_path&topic=content_id",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "research_and_statistics",
            module: "track-click"
         }
        },
        {
          text: "Policy papers and consultations",
          path: "/search/policy-papers-and-consultations?parent=%2Fbase_path&topic=content_id",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "policy_and_engagement",
            module: "track-click"
          }
        },
        {
          text: "Transparency and freedom of information releases",
          path: "/search/transparency-and-freedom-of-information-releases?parent=%2Fbase_path&topic=content_id",
          data_attributes: {
            track_category: "SeeAllLinkClicked",
            track_action: "/base_path",
            track_label: "transparency",
            module: "track-click"
          }
        }
      ]
      assert_equal subject.supergroup_sections, result_hash
    end
  end
end
