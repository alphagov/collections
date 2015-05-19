require 'test_helper'

describe SubtopicsController do
  describe "GET subcategory with a valid sector tag and subcategory" do
    setup do
      collections_api_has_content_for("/oil-and-gas/wells")

      Collections::Application.config.search_client.stubs(:unified_search).with(
        count: "0",
        filter_specialist_sectors: ["oil-and-gas/wells"],
        facet_organisations: "1000",
      ).returns(
        rummager_has_specialist_sector_organisations(
          "oil-and-gas/wells",
        )
       )
    end

    it "requests the tag from the Content API and assign it" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      assert_equal "Example title", assigns(:subcategory).title
      assert_equal "example description", assigns(:subcategory).description
    end

    it "requests and assign the artefacts for the tag from the Content API" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      artefact = assigns(:groups).first.artefact
      assert_equal "Oil rigs", artefact.name
    end

    it "sets the correct slimmer headers" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      artefact = JSON.parse(response.headers["X-Slimmer-Artefact"])
      primary_tag = artefact["tags"][0]

      assert_equal "/oil-and-gas", primary_tag["content_with_tag"]["web_url"]
      assert_equal "Oil and gas", primary_tag["title"] # lowercase due to the humanisation of slug in test helpers

      assert_equal "specialist-sector", response.headers["X-Slimmer-Format"]
    end

    it "sets expiry headers for 30 minutes" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end

    it "links to the organisations" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      organisations = assigns(:organisations)
      assert_equal '<a class="organisation-link" ' \
        'href="/government/organisations/department-of-energy-climate-change">' \
        'Department of Energy &amp; Climate Change</a>', \
        organisations.array_of_links.first
    end

    it "returns a 404 status for GET subcategory with an invalid subcategory tag" do
      collections_api_has_no_content_for("/oil-and-gas/coal")
      get :show, sector: "oil-and-gas", subcategory: "coal"

      assert_equal 404, response.status
    end
  end

  describe "invalid slugs" do
    it "returns a cacheable 404 without calling content_api if the sector subcategory slug is invalid" do
      get :show, sector: "oil-and-gas", subcategory: "this & that"

      assert_equal "404", response.code
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end
  end

  describe 'GET latest_changes' do
    let(:stub_subcategory) {
      stub('Subtopic',
        slug: 'intellectual-property/copyright',
        title: 'Copyright',
        description: 'Managing copyright, exceptions, notices',
        parent_sector: stub('ParentSector'),
        parent_sector_title: 'Intellectual property',
        changed_documents: [],
        combined_title: 'Intellectual property: Copyright',
        documents_start: 0,
        documents_total: 50,
      )
    }

    before do
      # we already test the organisation facet behaviour in the 'GET subcategory'
      # block above, so let's stub it out here completely to keep these tests simpler
      @controller.stubs(:sub_sector_organisations).returns([])
      Subtopic.stubs(:find).returns(stub_subcategory)
    end

    it 'finds the requested subcategory' do
      Subtopic.expects(:find)
                    .with('intellectual-property/copyright', {})
                    .returns(stub_subcategory)

      get :latest_changes, sector: 'intellectual-property', subcategory: 'copyright'

      assigns(:subcategory).must_equal stub_subcategory
    end

    it 'uses pagination parameters to find the subcategory' do
      Subtopic.expects(:find)
                    .with('intellectual-property/copyright', has_entries(start: 10, count: 20))
                    .returns(stub_subcategory)

      get :latest_changes, sector: 'intellectual-property',
                           subcategory: 'copyright',
                           start: '10',
                           count: '20'

      assigns(:subcategory).must_equal stub_subcategory
    end
  end
end
