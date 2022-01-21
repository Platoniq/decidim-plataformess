# frozen_string_literal: true
# This migration comes from decidim_decidim_peertube (originally 20211224183443)

class CreateDecidimPeertubeVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_peertube_videos do |t|
      t.references :decidim_component, foreign_key: { to_table: :decidim_components }, index: { name: "index_decidim_peertube_videos_on_component" }
      t.references :peertube_user, foreign_key: { to_table: :decidim_peertube_users }, index: { name: "index_decidim_peertube_videos_on_peertube_user" }

      t.string :peertube_video_id
      t.integer :peertube_channel_id

      t.string :video_url
      t.string :rtmp_url

      t.jsonb :data

      t.timestamps
    end
  end
end
