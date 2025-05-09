class MinistersIndexPresenter
  def initialize(content_item_data)
    @content_item_data = content_item_data
  end

  def lead_paragraph
    @content_item_data.fetch("details", {})["body"]
  end

  def is_during_reshuffle?
    @content_item_data.fetch("details", {})["reshuffle"]
  end

  def reshuffle_messaging
    @content_item_data.dig("details", "reshuffle", "message")
  end

  def cabinet_ministers
    ordered_cabinet_ministers = @content_item_data.dig("links", "ordered_cabinet_ministers") || []
    ordered_cabinet_ministers.map do |minister_data|
      Minister.new(minister_data)
    end
  end

  def also_attends_cabinet
    ordered_also_attends_cabinet = @content_item_data.dig("links", "ordered_also_attends_cabinet") || []
    ordered_also_attends_cabinet.map do |minister_data|
      Minister.new(minister_data)
    end
  end

  def by_organisation
    ordered_ministerial_departments = @content_item_data.dig("links", "ordered_ministerial_departments") || []
    ordered_ministerial_departments.map do |department_data|
      Department.new(
        url: department_data.fetch("web_url"),
        title: department_data.fetch("title"),
        crest: department_data.dig("details", "logo", "crest"),
        formatted_title: department_data.dig("details", "logo", "formatted_title"),
        brand: department_data.dig("details", "brand"),
        roles: department_data.dig("links", "ordered_roles") || [],
        ministers: (department_data.dig("links", "ordered_ministers") || []).map do |minister_data|
          Minister.new(minister_data)
        end,
      )
    end
  end

  Department = Struct.new(:url, :title, :crest, :formatted_title, :brand, :roles, :ministers, keyword_init: true)

  def whips
    ordered_whip_organisations.each do |whip_org|
      ordered_whip_organisation = @content_item_data.dig("links", whip_org.item_key) || []
      whip_org.ministers = ordered_whip_organisation.map do |minister_data|
        Minister.new(minister_data, whip_only: true)
      end
    end
  end

  class Minister
    def initialize(data, whip_only: false)
      @data = data
      @whip_only = whip_only
    end

    def person_url
      @data["web_url"]
    end

    def name
      @data.fetch("title").gsub("The Rt Hon", "").strip
    end

    def honorific
      @data.dig("details", "privy_counsellor") ? "The Rt Hon" : ""
    end

    def image_url
      @data.dig("details", "image", "url")
    end

    def image_alt
      @data.dig("details", "image", "alt_text")
    end

    def roles
      roles = current_role_appointments.map { |role_app|
        Role.new(
          id: role_app.dig("links", "role").first.fetch("content_id"),
          title: role_app.dig("links", "role").first.fetch("title"),
          url: role_app.dig("links", "role").first["web_url"],
          seniority: role_app.dig("links", "role").first.fetch("details").fetch("seniority", 1000),
          payment_info: role_app.dig("links", "role").first.dig("details", "role_payment_type"),
          whip: role_app.dig("links", "role").first.dig("details", "whip_organisation", "label").present?,
        )
      }.sort_by(&:seniority)

      roles = roles.select(&:whip) if @whip_only
      roles
    end

    def roles_for_department(department)
      org_role_ids = department.roles.map { |role| role["content_id"] }

      roles.select do |role|
        org_role_ids.include?(role.id)
      end
    end

    def role_payment_info
      roles.map(&:payment_info).compact.uniq
    end

    Role = Struct.new(:id, :title, :url, :seniority, :payment_info, :whip, keyword_init: true)

  private

    def current_role_appointments
      (@data.dig("links", "role_appointments") || []).select do |role_app|
        role_app.dig("details", "current") && role_app.dig("links", "role").first["web_url"].present?
      end
    end
  end

private

  def ordered_whip_organisations
    [
      WhipOrganisation.new(
        item_key: "ordered_house_of_commons_whips",
        name_key: "house_of_commons",
      ),
      WhipOrganisation.new(
        item_key: "ordered_junior_lords_of_the_treasury_whips",
        name_key: "junior_lords_of_the_treasury",
      ),
      WhipOrganisation.new(
        item_key: "ordered_assistant_whips",
        name_key: "assistant_whips",
      ),
      WhipOrganisation.new(
        item_key: "ordered_house_lords_whips",
        name_key: "house_of_lords",
      ),
      WhipOrganisation.new(
        item_key: "ordered_baronesses_and_lords_in_waiting_whips",
        name_key: "baronesses_and_lords_in_waiting",
      ),
    ]
  end

  WhipOrganisation = Struct.new(:item_key, :name_key, :ministers, keyword_init: true)
end
