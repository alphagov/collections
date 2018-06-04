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
              crest: "eo"
            }
          }
        ],
        ordered_ministerial_departments: [
          {
            title: "Attorney General's Office",
            href: "/government/organisations/attorney-generals-office"
          },
        ],
        ordered_non_ministerial_departments: [],
        ordered_agencies_and_other_public_bodies: [],
        ordered_high_profile_groups: [],
        ordered_public_corporations: [],
        ordered_devolved_administrations: []
      }
    }.with_indifferent_access
  end
end
