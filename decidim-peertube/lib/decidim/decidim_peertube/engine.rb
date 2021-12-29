# frozen_string_literal: true

require "rails"
require "decidim/core"
require "decidim/decidim_peertube/awesome_helpers"

module Decidim
  module DecidimPeertube
    # This is the engine that runs on the public interface of decidim_peertube.
    class Engine < ::Rails::Engine
      include AwesomeHelpers

      isolate_namespace Decidim::DecidimPeertube

      routes do
        resources :sessions
      end

      initializer "decidim.middleware" do |app|
        app.config.middleware.insert_after Decidim::CurrentOrganization, Decidim::DecidimPeertube::CurrentConfig
      end

      # Prepare a zone to create overrides
      # https://edgeguides.rubyonrails.org/engines.html#overriding-models-and-controllers
      # overrides
      config.to_prepare do
        if DecidimPeertube.config[:scoped_admins] != :disabled
          # override user's admin property
          Decidim::User.include(UserOverride)
          # redirect unauthorized scoped admins to allowed places
          Decidim::ErrorsController.include(AdminNotFoundRedirect)
        end

        # TODO: move to include overrides
        Dir.glob("#{Engine.root}/app/awesome_overrides/**/*_override.rb").each do |override|
          require_dependency override
        end
      end

      initializer "decidim_peertube.view_helpers" do
        ActionView::Base.include AwesomeHelpers
      end

      initializer "decidim_decidim_peertube.assets" do |app|
        app.config.assets.precompile += if version_prefix == "v0.23"
                                          %w(legacy_decidim_decidim_peertube_manifest.js decidim_decidim_peertube_manifest.css)
                                        else
                                          %w(decidim_decidim_peertube_manifest.js decidim_decidim_peertube_manifest.css)
                                        end
        # add to precompile any present theme asset
        Dir.glob(Rails.root.join("app/assets/themes/*.*")).each do |path|
          app.config.assets.precompile << path
        end
      end

      initializer "decidim_decidim_peertube.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::DecidimPeertube::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::DecidimPeertube::Engine.root}/app/views")
      end

      initializer "decidim_decidim_peertube.content_blocks" do |_app|
        # === Home Map block ===
        Decidim.content_blocks.register(:homepage, :awesome_map) do |content_block|
          content_block.cell = "decidim/decidim_peertube/content_blocks/map"
          content_block.settings_form_cell = "decidim/decidim_peertube/content_blocks/map_form"
          content_block.public_name_key = "decidim.decidim_peertube.content_blocks.map.name"

          content_block.settings do |settings|
            settings.attribute :title, type: :text, translated: true

            settings.attribute :map_height, type: :integer, default: 500
            settings.attribute :map_center, type: :string, default: ""
            settings.attribute :map_zoom, type: :integer, default: 8
            settings.attribute :truncate, type: :integer, default: 255
            settings.attribute :collapse, type: :boolean, default: false
            settings.attribute :menu_amendments, type: :boolean, default: true
            settings.attribute :menu_meetings, type: :boolean, default: true
            settings.attribute :menu_hashtags, type: :boolean, default: true

            settings.attribute :show_not_answered, type: :boolean, default: true
            settings.attribute :show_accepted, type: :boolean, default: true
            settings.attribute :show_withdrawn, type: :boolean, default: false
            settings.attribute :show_evaluating, type: :boolean, default: true
            settings.attribute :show_rejected, type: :boolean, default: false
          end
        end
        # === TODO: processes groups map block ===
      end
    end
  end
end