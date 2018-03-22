require 'test_helper'

include RummagerHelpers
include TaxonHelpers

describe TaxonPresenter do
  describe 'options' do
    let(:content_hash) { funding_and_finance_for_students_taxon }
    let(:content_item) { ContentItem.new(content_hash) }
    let(:taxon) { Taxon.new(ContentItem.new(content_hash)) }
    let(:child_taxon) { taxon.child_taxons.first }
    let(:taxon_presenter) { TaxonPresenter.new(taxon) }

    describe '#options_for_child_taxon' do
      describe 'root options' do
        before :each do
          stub_content_for_taxon([taxon.content_id], generate_search_results(15))
        end

        subject { taxon_presenter.options_for_child_taxon(index: 0) }

        it 'contains the track-click module' do
          assert_equal('track-click', subject[:module])
        end

        it 'contains the navGridContentClicked track_category' do
          assert_equal('navGridContentClicked', subject[:track_category])
        end

        it 'contains track-action equal to the index + 1' do
          assert_equal('1', subject[:track_action])
        end

        it 'contains track_label equal to the base path of the child taxon' do
          assert_equal(child_taxon.base_path, subject[:track_label])
        end
      end

      describe 'dimensions' do
        subject { taxon_presenter.options_for_child_taxon(index: 0)[:track_options] }

        describe 'dimension 26 - 1 or 2 (depend if there is leaf grid section or not)' do
          it 'is 2 because there is a leaf grid section' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(15))
            assert_equal('2', subject[:dimension26])
          end

          it 'is 1 because there is no leaf grid section' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(0))
            assert_equal('1', subject[:dimension26])
          end
        end

        describe 'dimension 27 - total number of links on page (incl main and leaf section)' do
          it 'contains the title of tagged content item' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(15))
            assert_equal('16', subject[:dimension27])
          end
        end

        describe 'dimension 28 - number of child taxons' do
          it 'contains the number of child taxons' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(15))
            assert_equal('1', subject[:dimension28])
          end
        end

        describe 'dimension 29 - title of the child taxon' do
          it 'contains the title of tagged content item' do
            stub_content_for_taxon([taxon.content_id], generate_search_results(15))
            assert_equal(child_taxon.title, subject[:dimension29])
          end
        end
      end
    end
  end

  describe 'supergroup_sections' do
    it 'returns a list of supergroup details' do
      taxon = mock
      taxon.stubs(:section_content).returns([])
      taxon.stubs(:base_path)
      taxon_presenter = TaxonPresenter.new(taxon)

      taxon_presenter.sections.each do |section|
        assert_equal(%i(show_section title documents see_more_link), section.keys)
      end
    end
  end

  describe 'guidance_and_regulation_section' do
    it 'checks whether guidance section should be shown' do
      taxon = mock
      taxon.stubs(:section_content).returns([])
      taxon_presenter = TaxonPresenter.new(taxon)

      refute taxon_presenter.show_section?("guidance_and_regulation")
    end

    it 'formats guidance and regulation content except guides for document list' do
      guidance_content = [
        Document.new(
          title: "16 to 19 funding: advanced maths premium",
          description: "The advanced maths premium is funding for additional students",
          public_updated_at: "2018-02-28T08:01:00.000+00:00",
          base_path: "/guidance/16-to-19-funding-advanced-maths-premium",
          content_store_document_type: "detailed_guide",
          organisations: 'Department for Education and Ofsted'
        )
      ]

      expected = [
        {
          link: {
            text: "16 to 19 funding: advanced maths premium",
            path: "/guidance/16-to-19-funding-advanced-maths-premium"
          },
          metadata: {
            public_updated_at: "2018-02-28T08:01:00.000+00:00",
            organisations: 'Department for Education and Ofsted',
            document_type: "Detailed guide"
          },
        }
      ]

      taxon = mock
      taxon.stubs(:section_content).returns(guidance_content)
      taxon_presenter = TaxonPresenter.new(taxon)

      assert_equal expected, taxon_presenter.section_document_list("guidance_and_regulation")
    end

    it 'formats guides content for document list' do
      guide_content = [
        Document.new(
          title: "If your child is taken into care",
          description: "What happens when a child is taken into care - who is responsible for what, care proceedings, care orders, going to court and the role of Cafcass",
          public_updated_at: "2018-02-28T08:01:00.000+00:00",
          base_path: "/if-your-child-is-taken-into-care",
          content_store_document_type: "guide",
          organisations: 'Department for Education'
        )
      ]

      expected = [
        {
          link: {
            text: "If your child is taken into care",
            path: "/if-your-child-is-taken-into-care",
            description: "What happens when a child is taken into care - who is responsible for what, care proceedings, care orders, going to court and the role of Cafcass",
          },
          metadata: {
            document_type: "Guide"
          },
        }
      ]

      taxon = mock
      taxon.stubs(:section_content).returns(guide_content)
      taxon_presenter = TaxonPresenter.new(taxon)

      assert_equal expected, taxon_presenter.section_document_list("guidance_and_regulation")
    end

    it 'formats the link to the guidance and regulation finder page' do
      taxon = mock
      taxon.stubs(:guidance_and_regulation_content).returns([])
      taxon.stubs(:base_path).returns("/foo")
      taxon_presenter = TaxonPresenter.new(taxon)

      expected_link_details = {
        text: "See all guidance and regulation",
        url: "/search/advanced?group=guidance_and_regulation&topic=%2Ffoo"
      }

      assert_equal expected_link_details, taxon_presenter.section_finder_link("guidance_and_regulation")
    end
  end

  describe 'services_section' do
    it 'formats services content for document list' do
      services_content = [
        Document.new(
          title: 'Register as a schools financial health checks supplier',
          description: 'Register to be added to the directory of schools financial health checks suppliers.',
          public_updated_at: '2018-02-28T08:01:00.000+00:00',
          base_path: '/publications/schools-financial-health-checks-supplier-registration-form',
          content_store_document_type: 'form',
          organisations: 'Department for Education and Ofsted'
        )
      ]

      expected = [
        {
          link: {
            text: 'Register as a schools financial health checks supplier',
            path: '/publications/schools-financial-health-checks-supplier-registration-form',
            description: 'Register to be added to the directory of schools financial health checks suppliers.',
          }
        }
      ]

      taxon = mock
      taxon.stubs(:section_content).returns(services_content)
      taxon_presenter = TaxonPresenter.new(taxon)

      assert_equal expected, taxon_presenter.section_document_list("services")
    end
  end

  describe 'policy_and_engagement_section' do
    it 'formats policy and engagement content for document list' do
      policy_and_engagement_content = [
        Document.new(
          title: 'Review of Children in Need',
          public_updated_at: '2018-02-28T08:01:00.000+00:00',
          base_path: '/government/publications/review-of-children-in-need',
          content_store_document_type: 'policy_paper',
          organisations: 'Department for Education'
        )
      ]

      expected = [
        {
          link: {
            text: 'Review of Children in Need',
            path: '/government/publications/review-of-children-in-need'
          },
          metadata: {
            public_updated_at: '2018-02-28T08:01:00.000+00:00',
            organisations: 'Department for Education',
            document_type: 'Policy paper'
          },
        }
      ]

      taxon = mock
      taxon.stubs(:section_content).returns(policy_and_engagement_content)
      taxon_presenter = TaxonPresenter.new(taxon)

      assert_equal expected, taxon_presenter.section_document_list('policy_and_engagement')
    end
  end

  describe 'news_and_communications_section' do
    it 'formats news and communications content for document list' do
      news_and_communications_content = [
        Document.new(
          title: 'Education Secretary tours the Midlands and North of England',
          public_updated_at: '2018-02-28T08:01:00.000+00:00',
          base_path: '/government/news/education-secretary-tours-the-midlands-and-north-of-england',
          content_store_document_type: 'news_story',
          organisations: 'Department for Education and Ofsted'
        )
      ]

      expected = [
        {
          link: {
            text: 'Education Secretary tours the Midlands and North of England',
            path: '/government/news/education-secretary-tours-the-midlands-and-north-of-england'
          },
          metadata: {
            public_updated_at: '2018-02-28T08:01:00.000+00:00',
            organisations: 'Department for Education and Ofsted',
            document_type: 'News story'
          },
        }
      ]

      taxon = mock
      taxon.stubs(:section_content).returns(news_and_communications_content)
      taxon_presenter = TaxonPresenter.new(taxon)

      assert_equal expected, taxon_presenter.section_document_list('news_and_communications')
    end
  end

  describe 'transparency_section' do
    it 'formats transparency content for document list' do
      transparency_content = [
        Document.new(
          title: 'Race Disparity Audit',
          public_updated_at: '2018-02-28T08:01:00.000+00:00',
          base_path: '/government/publications/race-disparity-audit',
          content_store_document_type: 'research',
          organisations: 'Department for Education'
        )
      ]

      expected = [
        {
          link: {
            text: 'Race Disparity Audit',
            path: '/government/publications/race-disparity-audit'
          },
          metadata: {
            public_updated_at: '2018-02-28T08:01:00.000+00:00',
            organisations: 'Department for Education',
            document_type: 'Research'
          },
        }
      ]

      taxon = mock
      taxon.stubs(:section_content).returns(transparency_content)
      taxon_presenter = TaxonPresenter.new(taxon)

      assert_equal expected, taxon_presenter.section_document_list('transparency')
    end
  end

  describe 'topic_grid_section' do
    it 'checks whether topic grid section should be shown' do
      taxon = mock
      taxon.stubs(:child_taxons).returns([])
      taxon_presenter = TaxonPresenter.new(taxon)

      refute taxon_presenter.show_subtopic_grid?
    end
  end
end
