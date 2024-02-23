# frozen_string_literal: true

module Plataformess
  module Multimedia
    class SyncAllJob < ApplicationJob
      queue_as :default

      def perform(organization_id)
        media_links = media_links(organization_id)
        Rails.logger.info "SyncAllJob: #{media_links.count} media links to process"
        return if media_links.empty?

        store_result(organization_id, media_links.map { |media_link| process_media_link(media_link) })
      end

      private

      def store_result(organization_id, result)
        File.write(Rails.root.join("tmp/multimedia/#{organization_id}.json"), result.to_json)
      end

      def media_links(organization_id)
        @media_links ||= Decidim::Conferences::MediaLink.left_outer_joins(conference: :scope)
                                                        .where(conference: { decidim_organization_id: organization_id })
                                                        .order(updated_at: :desc)
      end

      def process_media_link(media_link)
        {
          title: media_link.title,
          date: media_link.date,
          link: process_link(media_link.link),
          conference_slug: media_link.conference.slug,
          scope: media_link.conference.scope.present? ? media_link.conference.scope.name : nil
        }
      end

      def process_link(link)
        return peertube_embed_url(link) if link.match?("peertube")

        link
      end

      def peertube_embed_url(url)
        url.match?("watch") ? url.gsub("watch", "embed") : url.gsub("/w/", "/videos/embed/")
      end
    end
  end
end
