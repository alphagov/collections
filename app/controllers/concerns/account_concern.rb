# frozen_string_literal: true

module AccountConcern
  extend ActiveSupport::Concern

  included do
    include GovukPersonalisation::AccountConcern

    before_action do
      set_slimmer_headers(
        remove_search: true,
        show_accounts: logged_in? ? "signed-in" : "signed-out",
      )
    end
  end
end
