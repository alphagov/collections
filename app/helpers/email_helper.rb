module EmailHelper
  def whitehall_atom_url
    equivalent_whitehall_url + ".atom"
  end

  def whitehall_email_url
    whitehall_base_email_sign_up_url + whitehall_atom_url
  end

  def taxon_is_live?(presented_taxon)
    presented_taxon.live_taxon?
  end

private

  WHITEHALL_EMAIL_SIGNUP_PATH = "/government/email-signup/new?email_signup[feed]=".freeze

  def root
    Plek.new.website_root
  end

  def whitehall_base_email_sign_up_url
    root + WHITEHALL_EMAIL_SIGNUP_PATH
  end

  def equivalent_whitehall_url
    root + request.fullpath
  end
end
