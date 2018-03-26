require 'test_helper'

include RummagerHelpers
include TaxonHelpers

describe SupergroupSections::Sections do
  let(:taxon_id) { '12345' }
  let(:base_path) { '/base/path' }
  let(:sections) { SupergroupSections::Sections.new(taxon_id, base_path) }
  let(:policy_supergroup) { PolicyAndEngagement.new }
  let(:services_supergroup) { Service.new }
  let(:guidance_and_regulation_supergroup) { GuidanceAndRegulations.new }
  let(:news_and_communications_supergroup) { NewsAndCommunications.new }
  let(:transparency_supergroup) { Transparency.new }

  describe '#section_document_list' do
    # There are3 different metadata display rules for supergroups.
    # The following 3 tests test these different rules.
    it 'returns a list for a supergroup' do
      stub_tagged_content_search(policy_supergroup, 'policy_paper')

      expected = [
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content'
          },
          metadata: {
            public_updated_at: '2018-02-28T08:01:00.000+00:00',
            organisations: 'Tagged Content Organisation',
            document_type: 'Policy paper'
          }
        }
      ]

      assert_equal expected, sections.section_document_list(policy_supergroup)
    end

    it 'returns document list for services supergroup' do
      stub_tagged_content_search(services_supergroup, 'form')

      expected = [
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content',
            description: 'Description of tagged content'
          }
        }
      ]

      assert_equal expected, sections.section_document_list(services_supergroup)
    end

    it 'returns document list for guides' do
      stub_tagged_content_search(guidance_and_regulation_supergroup, 'guide')

      expected = [
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content',
            description: 'Description of tagged content',
          },
          metadata: {
            document_type: 'Guide'
          }
        }
      ]

      assert_equal expected, sections.section_document_list(guidance_and_regulation_supergroup)
    end
  end

  describe '#section_finder_link' do
    it 'returns info for link to finder page' do
      expected = {
        text: 'See all guidance and regulation',
        url: '/search/advanced?group=guidance_and_regulation&topic=%2Fbase%2Fpath'
      }

      assert_equal expected, sections.section_finder_link(guidance_and_regulation_supergroup.name)
    end
  end

  describe '#show_section?' do
    it 'returns true when section has tagged content' do
      policy_supergroup
        .stubs(:content)
        .returns(tagged_content('policy_paper'))

      assert sections.show_section?(policy_supergroup)
    end

    it 'returns false when section has no tagged content' do
      policy_supergroup
        .stubs(:content)
        .returns([])

      refute sections.show_section?(policy_supergroup)
    end
  end

  def stub_tagged_content_search(supergroup, doc_type)
    supergroup
      .stubs(:tagged_content)
      .with(taxon_id)
      .returns(tagged_content(doc_type))
  end

  def tagged_content(doc_type)
    [
      Document.new(
        title: 'Tagged Content Title',
        description: 'Description of tagged content',
        public_updated_at: '2018-02-28T08:01:00.000+00:00',
        base_path: '/government/tagged/content',
        content_store_document_type: doc_type,
        organisations: 'Tagged Content Organisation'
      )
    ]
  end
end
