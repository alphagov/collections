require 'test_helper'

describe Supergroups::Services do
  include RummagerHelpers

  let(:taxon_id) { '12345' }
  let(:service_supergroup) { Supergroups::Services.new }

  describe '#document_list' do
    it 'returns a document list for the services supergroup' do
      MostPopularContent.any_instance
        .stubs(:fetch)
        .returns(section_tagged_content_list('form', 4))

      expected = [
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content',
            description: 'Description of tagged content',
            data_attributes: {
              track_category: "servicesDocumentListClicked",
              track_action: 1,
              track_label: '/government/tagged/content'
            }
          }
        }
      ]

      assert_equal expected, service_supergroup.document_list(taxon_id)
    end

    it 'returns a promoted content list for the services supergroup' do
      MostPopularContent.any_instance
        .stubs(:fetch)
        .returns(section_tagged_content_list('form'))

      expected = [
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content',
            description: 'Description of tagged content',
            data_attributes: {
              track_category: "servicesHighlightBoxClicked",
              track_action: 1,
              track_label: '/government/tagged/content'
            }
          }
        }
      ]

      assert_equal expected, service_supergroup.promoted_content(taxon_id)
    end
  end
end
