module EmailHelper
  def whitehall_atom_url
    "#{equivalent_whitehall_url}.atom"
  end

  def email_alert_frontend_signup_url(taxon)
    root + "/email-signup?link=#{taxon.base_path}"
  end

  def taxon_is_live?(presented_taxon)
    presented_taxon.live_taxon?
  end

private

  def root
    Plek.new.website_root
  end

  def equivalent_whitehall_url
    root + request.fullpath
  end
end
