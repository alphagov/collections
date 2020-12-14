class CoronavirusLocalRestrictionsConstraint
  def matches?(*)
    !Rails.env.production?
  end
end
