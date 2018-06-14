module Organisations
  class PeoplePresenter
    include ActionView::Helpers::UrlHelper
    attr_reader :org

    def initialize(organisation)
      @org = organisation
    end

    def ministers
      all_ministers = []

      @org.ordered_ministers && @org.ordered_ministers.each do |minister|
        minister_multiple_roles = all_ministers.select do |all_ministers_item|
          all_ministers_item[:heading_text] === minister["name"]
        end

        if minister_multiple_roles.empty?
          all_ministers.push(formatted_minister_data(minister))
        else
          all_ministers.map do |all_ministers_item|
            if all_ministers_item[:heading_text].eql?(minister_multiple_roles.first[:heading_text])
              all_ministers_item[:extra_links] = multiple_role_links(all_ministers_item, minister)
            end
          end
        end
      end

      all_ministers
    end

  private

    def multiple_role_links(existing_minister_info, new_minister_info)
      existing_role_links = existing_minister_info[:extra_links]
      new_role_links = [
        {
          text: new_minister_info["role"],
          href: new_minister_info["role_href"]
        }
      ]

      existing_role_links.concat(new_role_links)
    end

    def formatted_minister_data(minister)
      data = {
        brand: @org.brand,
        href: minister["href"],
        extra_links: [
          {
            text: minister["role"],
            href: minister["role_href"]
          }
        ],
        metadata: minister["payment_type"],
        context: minister["name_prefix"],
        heading_text: minister["name"],
        heading_level: 3,
        extra_links_no_indent: true
      }

      if minister["image"]
        data[:image_src] = minister["image"]["url"]
        data[:image_alt] = minister["image"]["alt_text"]
      end

      data
    end
  end
end
