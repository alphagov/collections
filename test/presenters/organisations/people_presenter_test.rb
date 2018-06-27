require 'test_helper'

describe Organisations::PeoplePresenter do
  include RummagerHelpers
  include OrganisationHelpers

  describe 'ministers' do
    before :each do
      content_item = ContentItem.new(organisation_with_ministers)
      organisation = Organisation.new(content_item)
      @people_presenter = Organisations::PeoplePresenter.new(organisation)
    end

    it 'formats data for image card component' do
      expected = {
        title: "Our ministers",
        people: {
          brand: "attorney-generals-office",
          href: "/government/people/oliver-dowden",
          image_src: "/photo/s465_oliver-dowden",
          image_alt: "Oliver Dowden CBE MP",
          description: nil,
          metadata: nil,
          context: nil,
          heading_text: "Oliver Dowden CBE MP",
          heading_level: 0,
          extra_links_no_indent: true,
          extra_links: [
            {
              text: "Parliamentary Secretary (Minister for Implementation)",
              href: "/government/ministers/parliamentary-secretary"
            }
          ]
        }
      }

      assert_equal expected[:title], @people_presenter.all_people.first[:title]
      assert_equal expected[:people], @people_presenter.all_people.first[:people][0]
    end

    it 'handles ministers with multiple roles' do
      expected = {
        title: "Our ministers",
        people: {
          brand: "attorney-generals-office",
          href: "/government/people/theresa-may",
          image_src: "/photo/s465_theresa-may",
          image_alt: "Theresa May MP",
          description: nil,
          metadata: nil,
          context: "The Rt Hon",
          heading_text: "Theresa May MP",
          heading_level: 0,
          extra_links_no_indent: true,
          extra_links: [
            {
              text: "Prime Minister",
              href: "/government/ministers/prime-minister"
            },
            {
              text: "Minister for the Civil Service",
              href: "/government/ministers/minister-for-the-civil-service"
            }
          ]
        }
      }

      assert_equal expected[:title], @people_presenter.all_people.first[:title]
      assert_equal expected[:people], @people_presenter.all_people.first[:people][2]
    end

    it 'returns minister without image if no image available' do
      expected = {
        title: "Our ministers",
        people: {
          brand: "attorney-generals-office",
          href: "/government/people/stuart-andrew",
          description: nil,
          metadata: nil,
          context: nil,
          heading_text: "Stuart Andrew MP",
          heading_level: 0,
          extra_links_no_indent: true,
          extra_links: [
            {
              text: "Parliamentary Under Secretary of State",
              href: "/government/ministers/parliamentary-under-secretary-of-state--94"
            },
          ]
        }
      }

      assert_equal expected[:title], @people_presenter.all_people.first[:title]
      assert_equal expected[:people], @people_presenter.all_people.first[:people][1]
    end
  end

  describe 'non-ministers' do
    before :each do
      content_item = ContentItem.new(organisation_with_board_members)
      organisation = Organisation.new(content_item)
      @people_presenter = Organisations::PeoplePresenter.new(organisation)
    end

    it 'keeps the order for types of people' do
      content_item = ContentItem.new(organisation_with_no_people)
      organisation = Organisation.new(content_item)
      @no_people_presenter = Organisations::PeoplePresenter.new(organisation)

      expected = [
        {
          type: :ministers,
          title: "Our ministers",
          people: []
        },
        {
          type: :military_personnel,
          title: "Our senior military officials",
          people: []
        },
        {
          type: :board_members,
          title: "Our management",
          people: []
        },
        {
          type: :traffic_commissioners,
          title: "Traffic commissioners",
          people: []
        },
        {
          type: :special_representatives,
          title: "Special representatives",
          people: []
        },
        {
          type: :chief_professional_officers,
          title: "Chief professional officers",
          people: []
        }
    ]

      assert_equal expected, @no_people_presenter.all_people
    end

    it 'displays role as descriptions rather than links' do
      assert_equal "Cabinet Secretary", @people_presenter.all_people.third[:people][0][:description]
      assert_nil @people_presenter.all_people.third[:people][0][:extra_links]
    end

    it 'handles non-ministers with multiple roles' do
      expected = "Chief Executive of the Civil Service , Permanent Secretary (Cabinet Office)"

      assert_equal expected, @people_presenter.all_people.third[:people][1][:description]
    end

    it 'does not show images for non-important board members' do
      content_item = ContentItem.new(organisation_with_non_important_board_members)
      organisation = Organisation.new(content_item)
      @non_important_board_members = Organisations::PeoplePresenter.new(organisation)

      expected_important = {
        brand: "attorney-generals-office",
        href: "/government/people/jeremy-heywood",
        description: "Cabinet Secretary",
        metadata: nil,
        context: nil,
        heading_text: "Sir Jeremy Heywood",
        heading_level: 0,
        extra_links_no_indent: true,
        image_src: "/photo/s465_jeremy-heywood",
        image_alt: "Sir Jeremy Heywood"
      }


      expected_non_important = {
        brand: "attorney-generals-office",
        href: "/government/people/john-manzoni",
        description: "Chief Executive of the Civil Service ",
        metadata: nil,
        context: nil,
        heading_text: "John Manzoni",
        heading_level: 0,
        extra_links_no_indent: true
      }

      assert_equal expected_important, @non_important_board_members.all_people.third[:people][0]
      assert_equal expected_non_important, @non_important_board_members.all_people.third[:people][1]
    end

    it 'fetches small image' do
      assert_equal "/photo/s465_jeremy-heywood", @people_presenter.all_people.third[:people][0][:image_src]
    end
  end
end
