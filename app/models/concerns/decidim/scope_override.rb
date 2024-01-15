# frozen_string_literal: true

module Decidim
  module ScopeOverride
    extend ActiveSupport::Concern

    included do
      include Decidim::HasUploadValidations

      has_one_attached :banner_image
      validates_upload :banner_image, uploader: Decidim::HomepageImageUploader
    end
  end
end
