class Operator::BaseController < ApplicationController
  set_current_tenant_by_subdomain(:operator, :subdomain)
  layout "operator"
  before_action :store_ios_token, if: :logged_in?
  before_action :store_android_token, if: :logged_in?
  before_action :set_resource_scopes
  around_action :set_time_zone, if: :current_location
  before_action :reset_location, if: :logged_in?
  before_action :set_navigation

  def background_image
    @background_image = if current_tenant.present?
      if current_location.present? && current_location.has_photo?
        current_location.background_image
      else
        current_tenant.background_image
      end
    end
  end

  def pundit_user
    UserContext.new(current_user, current_tenant, current_location)
  end

  def store_ios_token
    if logged_in?
      match = request.user_agent.match(/.*deviceToken: (.*)/)
      return if match.nil? || match[1].blank?
      token = match[1]
      current_user.update(ios_token: token)
    end
  end

  def store_android_token
    if logged_in?
      match = request.user_agent.match(/.*token: (.*)/)
      return if match.nil? || match[1].blank?
      token = match[1]
      current_user.update(android_token: token)
    end
  end

  def set_navigation
    @navigation = NavigationFactory.for(
      logged_in?, 
      admin?, 
      current_tenant, 
      current_location,
      current_user)
  end

  private

  def set_resource_scopes
    if ActsAsScopable.current_scope_resources.empty?
      ActsAsScopable.current_scope_resources = [current_tenant, current_location]
    end

    if current_tenant.blank?
      redirect_to status: 404
    end
  end

  def set_time_zone(&block)
    Time.use_zone(current_location.time_zone, &block)
  end

  def reset_location
    if current_location.blank?
      log_out
      redirect_to root_path
    end
  end
end
