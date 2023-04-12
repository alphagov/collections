class EmbassiesIndexPresenter
  def initialize(embassies_index)
    @embassies_index = embassies_index
  end

  def title
    "Find a British embassy, high commission or consulate"
  end

  def details
    @embassies_index.content_item.details
  end

  def embassies_by_location
    details["world_locations"].map do |data|
      Embassy.new(data)
    end
  end

  class Embassy
    def initialize(data)
      @data = data
    end

    def name
      @data["name"]
    end

    def can_assist_british_nationals?
      %w[local remote].include?(@data["assistance_available"])
    end

    def can_assist_in_location?
      @data["assistance_available"] == "local"
    end

    def remote_office
      RemoteOffice.new(name: @data["remote_office"]["name"],
                       location: @data["remote_office"]["country"],
                       path: @data["remote_office"]["path"])
    end

    def organisations_with_embassy_offices
      @data["organisations_with_embassy_offices"].map do |o|
        Organisation.new(locality: o["locality"],
                         name: o["name"],
                         path: o["path"])
      end
    end

    Organisation = Struct.new(:name, :locality, :path, keyword_init: true)
    RemoteOffice = Struct.new(:name, :location, :path, keyword_init: true)
  end
end
