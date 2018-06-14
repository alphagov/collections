module OrganisationHelpers
  def organisation_with_ministers
    {
      title: "Attorney General's Office",
      details: {
        brand: "attorney-generals-office",
        ordered_ministers: [
          {
            name: "Oliver Dowden CBE MP",
            role: "Parliamentary Secretary (Minister for Implementation)",
            href: "/government/people/oliver-dowden",
            role_href: "/government/ministers/parliamentary-secretary",
            image: {
              url: "/photo/oliver-dowden",
              alt_text: "Oliver Dowden CBE MP"
            }
          },
          {
            name: "Stuart Andrew MP",
            role: "Parliamentary Under Secretary of State",
            href: "/government/people/stuart-andrew",
            role_href: "/government/ministers/parliamentary-under-secretary-of-state--94"
          },
          {
            name_prefix: "The Rt Hon",
            name: "Theresa May MP",
            role: "Prime Minister",
            href: "/government/people/theresa-may",
            role_href: "/government/ministers/prime-minister",
            image: {
              url: "/photo/theresa-may",
              alt_text: "Theresa May MP"
            }
          },
          {
            name_prefix: "The Rt Hon",
            name: "Theresa May MP",
            role: "Minister for the Civil Service",
            href: "/government/people/theresa-may",
            role_href: "/government/ministers/minister-for-the-civil-service",
            image: {
              url: "/photo/theresa-may",
              alt_text: "Theresa May MP"
            }
          }
        ]
      }
    }.with_indifferent_access
  end
end
