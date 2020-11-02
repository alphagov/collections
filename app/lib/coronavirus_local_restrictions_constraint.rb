class CoronavirusLocalRestrictionsConstraint
  def matches?(*)
    return false if Rails.env.production?

    true
  end
end
