# frozen_string_literal: true

module Decidim
  module Conferences
    module ConferencesControllerOverride
      extend ActiveSupport::Concern

      included do
        alias_method :original_conferences, :conferences

        private

        def conferences
          @conferences ||= if current_scope.nil?
                             original_conferences
                           elsif current_scope == "none"
                             original_conferences.query.where(scope: nil)
                           else
                             original_conferences.query.where(scope: current_scope)
                           end
        end

        def promoted_conferences
          @promoted_conferences ||= conferences.promoted
        end

        def current_scope
          @current_scope ||= params.dig(:filter, :with_scope)
        end
      end
    end
  end
end
