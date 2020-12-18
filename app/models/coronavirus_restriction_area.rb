class CoronavirusRestrictionArea
  def self.find(gss_code)
    all.find { |restriction| restriction.gss_code == gss_code }
  end

  def self.all
    @all ||= begin
      restriction_data = YAML.load_file(Rails.root.join("config/coronavirus_restriction_areas.yml"))
      restriction_data.map { |gss_code, attributes| new(gss_code, attributes) }
    end
  end

  attr_reader :gss_code, :name, :restrictions

  def initialize(gss_code, attributes)
    @gss_code = gss_code
    @name = attributes.fetch("name")
    @restrictions = attributes.fetch("restrictions", []).map do |restriction|
      Restriction.new(restriction)
    end
    raise "#{gss_code} does not have a current restriction" unless current_restriction
  end

  def current_restriction
    restrictions.select { |r| r.start_time.past? }.max_by(&:start_time)
  end

  def future_restriction
    restrictions.select { |r| r.start_time.future? }.min_by(&:start_time)
  end

  class Restriction
    attr_reader :alert_level, :start_time

    def initialize(attributes)
      @alert_level = attributes.fetch("alert_level")
      @start_time = Time.zone.parse(
        "#{attributes.fetch('start_date')} #{attributes.fetch('start_time')}",
      )
    end

    def tier_one?
      alert_level == 1
    end

    def tier_two?
      alert_level == 2
    end

    def tier_three?
      alert_level == 3
    end

    def tier_four?
      alert_level == 4
    end
  end
end
