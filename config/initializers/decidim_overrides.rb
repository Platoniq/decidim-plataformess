# frozen_string_literal: true

Rails.application.config.to_prepare do
  # Add banner image to scope model
  Decidim::Admin::ScopeForm.include(Decidim::Admin::ScopeFormOverride)
  Decidim::Admin::CreateScope.include(Decidim::Admin::CreateScopeOverride)
  Decidim::Scope.include(Decidim::ScopeOverride)
  # Allow filters on conferences controller
  Decidim::Conferences::ConferencesController.include(Decidim::Conferences::ConferencesControllerOverride)
end

# Register cell for scope model
Decidim.register_resource(:scope) do |resource|
  resource.model_class_name = "Decidim::Scope"
  resource.card = "decidim/scope"
end

# Remove default conferences URL from menu
Decidim.menu :menu do |menu|
  menu.remove_item :conferences
end
