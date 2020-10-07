class LocalRestriction
  attr_reader :gss_code

  def initialize(gss_code)
    @gss_code = gss_code
  end

  def all_restrictions
    @all_restrictions ||= YAML.load_file(file_name)
  end

  def restriction
    all_restrictions[gss_code] || {}
  end

  def file_name
    "lib/local_restrictions/local-restrictions.yaml"
  end

  def area_name
    restriction["name"]
  end

  def alert_level
    restriction["alert_level"]
  end

  def guidance
    restriction["guidance"]
  end

  def extra_restrictions
    restriction["extra_restrictions"]
  end

  def start_date
    restriction["start_date"]&.to_date
  end

  def end_date
    restriction["end_date"]&.to_date
  end
end
