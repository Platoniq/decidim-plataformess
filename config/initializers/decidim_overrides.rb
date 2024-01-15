# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::Admin::ScopeForm.include(Decidim::Admin::ScopeFormOverride)
  Decidim::Admin::CreateScope.include(Decidim::Admin::CreateScopeOverride)
  Decidim::Scope.include(Decidim::ScopeOverride)
end
