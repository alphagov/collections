class CoronavirusRestrictionArea
  def self.find(gss_code)
    all.find { |area| area.gss_code == gss_code }
  end

  def self.all
    @all ||= begin
      area_attributes = YAML.load_file(Rails.root.join("config/coronavirus_restriction_areas.yml"))
      area_attributes.map { |gss_code, attributes| new(gss_code, attributes) }
    end
  end

  attr_reader :gss_code, :name, :restrictions

  def initialize(gss_code, attributes)
    @gss_code = gss_code
    @name = attributes.fetch("name")
    @restrictions = attributes.fetch("restrictions", []).map do |restriction|
      Restriction.new(restriction)
    end
  end

  def current
    restrictions.select { |r| r.start_time.past? }
                .max_by(&:start_time)
  end

  def future
    restrictions.select { |r| r.start_time.future? }
                .min_by(&:start_time)
  end

  class Restriction
    attr_reader :alert_level, :start_time

    def initialize(attributes)
      @alert_level = attributes.fetch("alert_level")
      @start_time = Time.zone.parse(
        "#{attributes.fetch('start_date')} #{attributes.fetch('start_time')}"
      )
    end
  end
end
