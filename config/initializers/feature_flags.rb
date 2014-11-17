# This initializer will be replaced on deploy.
#
module Collections
  def self.email_signup_link_enabled?
    Rails.env.development? || Rails.env.test?
  end
end
