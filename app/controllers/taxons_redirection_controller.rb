# frozen_string_literal: true

class TaxonsRedirectionController < ApplicationController
  def redirect
    redirect_to_landing_page && return
  end

private

  def redirect_to_landing_page
    redirect_to("/coronavirus", status: :temporary_redirect)
  end
end
