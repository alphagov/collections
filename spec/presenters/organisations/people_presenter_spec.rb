RSpec.describe Organisations::PeoplePresenter do
  include SearchApiHelpers
  include OrganisationHelpers

  describe "ministers" do
    let(:people_presenter) { presenter_from_organisation_hash(organisation_with_ministers) }

    it "formats data for image card component" do
      expected = {
        title: "Our ministers",
        people: {
          brand: "attorney-generals-office",
          href: "/government/people/oliver-dowden",
          image_src: "/photo/oliver-dowden",
          description: nil,
          metadata: nil,
          heading_text: "Oliver Dowden CBE MP",
          lang: "en",
          heading_level: 0,
          extra_links_no_indent: true,
          extra_links: [
            {
              text: "Parliamentary Secretary (Minister for Implementation)",
              href: "/government/ministers/parliamentary-secretary",
            },
          ],
        },
      }

      expect(people_presenter.all_people.first[:title]).to eq(expected[:title])
      expect(people_presenter.all_people.first[:people][0]).to eq(expected[:people])
    end

    it "handles ministers with multiple roles" do
      expected = {
        title: "Our ministers",
        people: {
          brand: "attorney-generals-office",
          href: "/government/people/theresa-may",
          image_src: "/photo/theresa-may",
          description: nil,
          metadata: nil,
          heading_text: "The Rt Hon Theresa May MP",
          lang: "en",
          heading_level: 0,
          extra_links_no_indent: true,
          extra_links: [
            {
              text: "Prime Minister",
              href: "/government/ministers/prime-minister",
            },
            {
              text: "Minister for the Civil Service",
              href: "/government/ministers/minister-for-the-civil-service",
            },
          ],
        },
      }

      expect(people_presenter.all_people.first[:title]).to eq(expected[:title])
      expect(people_presenter.all_people.first[:people][2]).to eq(expected[:people])
    end

    it "orders minister roles by seniority" do
      expected = {
        title: "Our ministers",
        people: {
          brand: "attorney-generals-office",
          href: "/government/people/victoria-atkins",
          image_src: "/photo/victoria-atkins",
          description: nil,
          metadata: nil,
          heading_text: "Victoria Atkins MP",
          lang: "en",
          heading_level: 0,
          extra_links_no_indent: true,
          extra_links: [
            {
              text: "Minister of State",
              href: "/government/ministers/minister-of-state--61",
            },
            {
              text: "Minister for Afghan Resettlement",
              href: "/government/ministers/minister-for-afghan-resettlement",
            },
          ],
        },
      }
      expect(people_presenter.all_people.first[:people][3]).to eq(expected[:people])
    end

    it "returns minister without image if no image available" do
      expected = {
        title: "Our ministers",
        people: {
          brand: "attorney-generals-office",
          href: "/government/people/stuart-andrew",
          description: nil,
          metadata: nil,
          heading_text: "Stuart Andrew MP",
          lang: "en",
          heading_level: 0,
          extra_links_no_indent: true,
          extra_links: [
            {
              text: "Parliamentary Under Secretary of State",
              href: "/government/ministers/parliamentary-under-secretary-of-state--94",
            },
          ],
        },
      }

      expect(people_presenter.all_people.first[:title]).to eq(expected[:title])
      expect(people_presenter.all_people.first[:people][1]).to eq(expected[:people])
    end
  end

  describe "non-ministers" do
    let(:people_presenter) { presenter_from_organisation_hash(organisation_with_board_members) }

    it "keeps the order for types of people" do
      no_people_presenter = presenter_from_organisation_hash(organisation_with_no_people)

      expected = [
        {
          type: :ministers,
          title: "Our ministers",
          people: [],
          lang: false,
        },
        {
          type: :military_personnel,
          title: "Our senior military officials",
          people: [],
          lang: false,
        },
        {
          type: :board_members,
          title: "Our management",
          people: [],
          lang: false,
        },
        {
          type: :traffic_commissioners,
          title: "Traffic commissioners",
          people: [],
          lang: false,
        },
        {
          type: :special_representatives,
          title: "Special representatives",
          people: [],
          lang: false,
        },
        {
          type: :chief_professional_officers,
          title: "Chief professional officers",
          people: [],
          lang: false,
        },
      ]

      expect(no_people_presenter.all_people).to eq(expected)
    end

    it "displays role as descriptions rather than links" do
      expect(people_presenter.all_people.third[:people][0][:description]).to eq("Cabinet Secretary")
      expect(people_presenter.all_people.third[:people][0][:extra_links]).to be_nil
    end

    it "handles non-ministers with multiple roles" do
      expected = "Chief Executive of the Civil Service, Permanent Secretary (Cabinet Office)"

      expect(people_presenter.all_people.third[:people][1][:description]).to eq(expected)
    end

    it "does not show images for non-important board members" do
      non_important_board_members = presenter_from_organisation_hash(organisation_with_non_important_board_members)

      expected_important = {
        brand: "attorney-generals-office",
        href: "/government/people/jeremy-heywood",
        description: "Cabinet Secretary",
        metadata: "Unpaid",
        heading_text: "Sir Jeremy Heywood",
        lang: "en",
        heading_level: 0,
        extra_links_no_indent: true,
        image_src: "/photo/jeremy-heywood",
      }

      expected_non_important = {
        brand: "attorney-generals-office",
        href: "/government/people/john-manzoni",
        description: "Chief Executive of the Civil Service",
        metadata: nil,
        heading_text: "John Manzoni",
        lang: "en",
        heading_level: 0,
        extra_links_no_indent: true,
      }

      expect(non_important_board_members.all_people.third[:people][0]).to eq(expected_important)
      expect(non_important_board_members.all_people.third[:people][1]).to eq(expected_non_important)
    end

    it "fetches image" do
      expect(people_presenter.all_people.third[:people][0][:image_src]).to eq("/photo/jeremy-heywood")
    end
  end

  def presenter_from_organisation_hash(content)
    content_item = ContentItem.new(content)
    organisation = Organisation.new(content_item)
    Organisations::PeoplePresenter.new(organisation)
  end
end
