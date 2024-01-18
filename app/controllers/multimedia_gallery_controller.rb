# frozen_string_literal: true

class MultimediaGalleryController < Decidim::ApplicationController
  helper_method :media_links

  private

  def media_links
    @media_links ||= begin
      JSON.parse(File.read(Rails.root.join("tmp/multimedia_#{current_organization.id}.json"))).map(&:deep_symbolize_keys)
    rescue Errno::ENOENT
      []
    end
  end
end
