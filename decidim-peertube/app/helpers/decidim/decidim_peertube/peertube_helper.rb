# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module PeertubeHelper
      def edit_component_path
        Decidim::EngineRouter.admin_proxy(current_component.participatory_space).edit_component_path(current_component.id)
      end

      def peertube_embed_url
        url = current_component.settings.video_url
        url.match?("watch") ? url.gsub("watch", "embed") : url.gsub("/w/", "/videos/embed/")
      end
    end
  end
end
