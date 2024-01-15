# frozen_string_literal: true

module Decidim
  module Admin
    module ScopeFormOverride
      extend ActiveSupport::Concern

      included do
        attribute :banner_image
        attribute :remove_banner_image, :boolean, default: false

        validates :banner_image, passthru: { to: Decidim::Scope }
      end
    end
  end
end
