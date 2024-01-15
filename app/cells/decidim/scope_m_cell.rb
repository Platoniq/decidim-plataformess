# frozen_string_literal: true

module Decidim
  # This cell renders the Medium (:m) scope card
  # for an given instance of a Scope
  class ScopeMCell < Decidim::CardMCell
    include Decidim::ViewHooksHelper

    private

    def title
      decidim_html_escape(translated_attribute(model.name))
    end

    def description
      nil
    end

    def has_image?
      true
    end

    def resource_path
      Decidim::Conferences::Engine.routes.url_helpers.conferences_path(filter: { with_scope: model })
    end

    def resource_image_path
      model.attached_uploader(:banner_image).path
    end
  end
end
