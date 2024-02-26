# frozen_string_literal: true

module Decidim
  # This cell renders the scope card for an instance of a Scope
  # the default size is the Medium Card (:m)
  class ScopeCell < Decidim::ViewModel
    def show
      cell card_size, model
    end

    private

    def card_size
      "decidim/scope_m"
    end
  end
end
