# frozen_string_literal: true

module Decidim
  module DecidimPeertube
    module Admin
      class PeertubeVideosController < Decidim::Admin::Components::BaseController
        include HasPeertubeSession
        helper PeertubeHelper

        before_action :check_peertube_session, only: [:new, :create]

        def show
          # enforce_permission_to :show, :peertube_video
        end

        def edit
          # enforce_permission_to :edit, :peertube_video
        end

        def new
          # enforce_permission_to :create, :peertube_video

          @form = Decidim::DecidimPeertube::PeertubeVideoForm.new
        end

        def create
          # enforce_permission_to :create, :peertube_video

          @form = form(Decidim::DecidimPeertube::PeertubeVideoForm).from_params(params)

          Decidim::DecidimPeertube::CreateLiveVideo.call(@form, current_peertube_user.access_token, current_component) do
            on(:ok) do
              flash[:notice] = I18n.t("peertube_videos.create.success", scope: "decidim.decidim_peertube.admin")
              redirect_to edit_component_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("peertube_videos.create.invalid", scope: "decidim.decidim_peertube.admin")
              render action: "new"
            end
          end

          #   {
          #     "rtmpUrl": "...",
          #     "rtmpsUrl": "...",
          #     "streamKey": "...",
          #     "saveReplay": true,
          #     "permanentLive": true
          # }
        end
      end
    end
  end
end