module OrganisationsHelpers
  def ministerial_departments_hash
    {
      "title": "Departments, agencies and public bodies",
      details: {
        ordered_executive_offices: [
          {
            title: "Prime Minister's Office, 10 Downing Street",
            href: "/government/organisations/prime-ministers-office-10-downing-street",
            brand: "cabinet-office",
            logo: {
              formatted_title: "Prime Minister's Office, 10 Downing Street",
              crest: "eo",
            },
          },
        ],
        ordered_ministerial_departments: [
          {
            title: "Attorney General's Office",
            href: "/government/organisations/attorney-generals-office",
          },
        ],
        ordered_non_ministerial_departments: [],
        ordered_agencies_and_other_public_bodies: [],
        ordered_high_profile_groups: [],
        ordered_public_corporations: [],
        ordered_devolved_administrations: [],
      },
    }.with_indifferent_access
  end

  def non_ministerial_departments_hash
    {
      "title": "Departments, agencies and public bodies",
      details: {
        ordered_executive_offices: [],
        ordered_ministerial_departments: [],
        ordered_non_ministerial_departments: [
          {
            title: "The Charity Commission",
            href: "/government/organisations/charity-commission",
            brand: "department-for-business-innovation-skills",
            separate_website: true,
          },
        ],
        ordered_agencies_and_other_public_bodies: [
          {
            title: "Academy for Social Justice Commissioning",
            href: "/government/organisations/academy-for-social-justice-commissioning",
            brand: "ministry-of-justice",
          },
        ],
        ordered_high_profile_groups: [
          {
            title: "Bona Vacantia",
            href: "/government/organisations/bona-vacantia",
            brand: "attorney-generals-office",
          },
        ],
        ordered_public_corporations: [
          {
            title: "BBC",
            href: "/government/organisations/bbc",
            brand: "department-for-culture-media-sport",
          },
        ],
        ordered_devolved_administrations: [
          {
            title: "Northern Ireland Executive ",
            href: "/government/organisations/northern-ireland-executive",
            brand: nil,
          },
        ],
      },
    }.with_indifferent_access
  end

  def some_non_ministerial_departments_hash
    {
      "title": "Departments, agencies and public bodies",
      details: {
        ordered_non_ministerial_departments: [
          {
            title: "The Charity Commission",
            href: "/government/organisations/charity-commission",
            brand: "department-for-business-innovation-skills",
          },
        ],
      },
    }.with_indifferent_access
  end
end
