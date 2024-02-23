# frozen_string_literal: true

require "rake"

Rails.application.load_tasks

class MultimediaGalleryWorker
  include Sidekiq::Worker

  def perform(*_args)
    Rake::Task["plataformess:multimedia:sync:all"].invoke
  end
end
