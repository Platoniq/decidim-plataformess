# frozen_string_literal: true

namespace :plataformess do
  namespace :multimedia do
    namespace :sync do
      desc "Sync all media links"
      task all: :environment do
        Decidim::Organization.find_each do |organization|
          Plataformess::Multimedia::SyncAllJob.perform_now(organization.id)
        end
      end
    end
  end
end
