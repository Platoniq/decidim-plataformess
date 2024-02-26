# frozen_string_literal: true

module Decidim
  module Admin
    module CreateScopeOverride
      extend ActiveSupport::Concern

      included do
        private

        def create_scope
          Decidim.traceability.create!(
            Scope,
            form.current_user,
            {
              name: form.name,
              organization: form.organization,
              code: form.code,
              scope_type: form.scope_type,
              banner_image: form.banner_image,
              parent: @parent_scope
            },
            extra: {
              parent_name: @parent_scope.try(:name),
              scope_type_name: form.scope_type.try(:name)
            }
          )
        end
      end
    end
  end
end
