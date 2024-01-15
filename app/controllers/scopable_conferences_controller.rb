# frozen_string_literal: true

class ScopableConferencesController < Decidim::Conferences::ApplicationController
  include Decidim::ParticipatorySpaceContext

  helper_method :collection

  def index
    raise ActionController::RoutingError, "Not Found" if scope_type.nil? || scopes.empty?

    enforce_permission_to :list, :conference
  end

  private

  def scopes
    @scopes ||= Decidim::Scope.where(organization: current_organization, scope_type: scope_type)
  end

  def scope_type
    @scope_type ||= Decidim::ScopeType.where("name->>? ilike ?", "ca", "conferència").first
  end

  alias collection scopes
end
