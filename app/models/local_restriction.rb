class LocalRestriction
  def self.find(gss_code)
    all.find { |restriction| restriction.gss_code == gss_code }
  end

  def self.all
    @all ||= begin
      restriction_data = YAML.load_file(Rails.root.join("config/local_restrictions.yml"))
      restriction_data.map { |gss_code, data| new(gss_code, data) }
    end
  end

  attr_reader :gss_code, :area_name, :restrictions

  def initialize(gss_code, data)
    @gss_code = gss_code
    @area_name = data.fetch("name")
    @restrictions = data.fetch("restrictions", [])
  end

  def current_alert_level
    current["alert_level"] if current.present?
  end

  def future_alert_level
    future["alert_level"] if future.present?
  end

  def future_start_time
    return unless future

    Time.zone.parse("#{future['start_date']} #{future['start_time']}")
  end

  def current
    current_restrictions = restrictions.select do |rest|
      start_date = Time.zone.parse("#{rest['start_date']} #{rest['start_time']}")
      start_date.past?
    end

    current_restrictions.max_by { |rest| rest["start_date"] }
  end

  def future
    future_restrictions = restrictions.select do |rest|
      start_date = Time.zone.parse("#{rest['start_date']} #{rest['start_time']}")
      start_date.future?
    end

    future_restrictions.min_by { |rest| rest["start_date"] }
  end
end
